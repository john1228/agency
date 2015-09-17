class Order < ActiveRecord::Base
  include OrderAble
  before_create :detect_params
  after_save :backend_task #当订单完成支付时，生成课表
  default_scope { order(updated_at: :desc) }
  scope :unpaid, -> { where(status: STATUS[:unpaid]) }
  scope :pay, -> { where(status: STATUS[:pay]) }
  belongs_to :user
  belongs_to :service
  belongs_to :coach
  has_one :order_item, dependent: :destroy

  has_many :lessons, dependent: :destroy
  attr_accessor :item, :sku, :amount
  STATUS = {delete: -1, cancel: 0, unpaid: 1, pay: 2, complete: 4}
  PAY_TYPE = {alipay: 1, webchat: 2, jd: 3}
  alias_attribute :coupon, :coupons

  private
  def detect_params
    sku_info = Sku.find_by(sku: sku)
    course = sku_info.course
    #产品购买
    build_order_item(sku: sku, name: course.name, type: course.type, during: course.during,
                     cover: course.cover, price: sku_info.selling_price, amount: amount)
    #校验优惠券
    if coupon.present?
      using_coupon = Coupon.find_by(id: coupon)
      if using_coupon.blank? || !check_coupon(using_coupon) || using_coupon.min > (order_item.price * order_item.amount)
        errors.add(:coupon, '无效的优惠券')
        return false
      end
    end
    #限制数量
    if sku_info.limit > 0 && (sku_info.limit_detect(user_id) + order_item.amount) > sku_info.limit
      errors.add(:limit, '购买数量超出限制')
      return false
    end
    self.no = "#{Time.now.to_i}#{user_id}#{%w'0 1 2 3 4 5 6 7 8 9'.sample(3).join('')}"
    self.total = sku_info.selling_price*order_item.amount
    self.no = "#{Time.now.to_i}#{user_id}#{%w'0 1 2 3 4 5 6 7 8 9'.sample(3).join('')}"
    self.service_id = course.is_a?(ServiceCourse) ? sku_info.seller_id : course.coach.service.id
    self.coach_id = sku_info.seller_id if course.is_a?(Course)
    if using_coupon.present?
      self.pay_amount = using_coupon.discount > total ? 0 : (total-using_coupon.discount)
    else
      self.pay_amount = total
    end
    if pay_amount>0
      self.status = STATUS[:unpaid]
    else
      self.status = STATUS[:pay]
    end
    #优惠券更新
    if using_coupon.present?
      wallet = user.wallet
      wallet.with_lock do
        wallet.coupons.delete(using_coupon.id)
        wallet.action = WalletLog::ACTIONS['消费']
        wallet.save
      end
    end
    #库存更新
    if sku_info.store >= 0
      if sku_info.store<order_item.amount
        errors.add(:store, '库存不足')
        return false
      else
        Sku.where('sku LIKE ? and course_id=?', order_item.sku[0, 2] + '%', sku_info.course_id).map { |sku| sku.update(store: (sku_info.store - order_item.amount)) }
      end
    end

  end


  def backend_task
    case status
      when STATUS[:unpaid]
        OrderJob.set(wait: 2.hours).perform_later(id)
      when STATUS[:pay]
        #现在只购买一个课程,逻辑遵循一个课时走
        sku_info = Sku.find_by(sku: order_item.sku)
        course = sku_info.course
        if course.is_a?(Course)
          Lesson.create(order_id: id, sku: order_item.sku, coach_id: sku_info.seller_id, user: user, available: order_item.amount, used: 0,
                        exp: Date.today.next_day(course.exp), contact_name: contact_name, contact_phone: contact_phone) if lessons.blank?
          #钱的處理
          unless course.guarantee.eql?(Course::GUARANTEE)
            service = course.coach.service
            if service.blank?
              errors.add(:service, '该课程到私教没有服务号，无法购买')
              return false
            else
              wallet = Wallet.find_or_create_by(user: service)
              wallet.with_lock do
                wallet.balance += total
                wallet.action = WalletLog::ACTIONS['卖课收入']
                wallet.save
              end
            end
          end
          MessageJob.perform_later(sku_info.seller_id, MESSAGE['订单'] % [user.profile.name, sku_info.course_name, no])
          SmsJob.perform_later(course.coach.mobile, SMS['订单'], [user.profile.name, sku_info.course_name, no])
        else
          Lesson.create(order_id: id, sku: order_item.sku, user: user, available: order_item.amount, used: 0,
                        exp: Date.today.next_day(course.exp), contact_name: contact_name, contact_phone: contact_phone) if lessons.blank?
          #钱的處理
          wallet = Wallet.find_or_create_by(user_id: sku_info.seller_id)
          unless course.guarantee.eql?(Course::GUARANTEE)
            wallet.with_lock do
              wallet.balance += total
              wallet.action = WalletLog::ACTIONS['卖课收入']
              wallet.save
            end
          end
        end
        Sku.where('sku LIKE ?', order_item.sku[0, order_item.sku.rindex('-')] + '%').update_all("orders_count =  orders_count + #{order_item.amount}")
      #结算
      when STATUS[:cancel]
        sku_info = Sku.find_by(sku: order_item.sku)
        Sku.where('sku LIKE ?', order_item.sku[0, order_item.sku.rindex('-')] + '%').update_all(store: (sku_info.store + order_item.amount)) if sku_info.store > -1
        user.wallet.update(coupons: ((user.wallet.coupons||[]) + (coupons||'').split(',').map { |coupon| coupon.to_i }).uniq, bean: (user.wallet.bean + bean.to_i), action: WalletLog::ACTIONS['订单取消']) if coupons.present?||bean.present?
    end
  end
end

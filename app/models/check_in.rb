class CheckIn < Appointment
  default_scope -> { order(id: :desc) }
  belongs_to :coach
  belongs_to :user
  belongs_to :lesson
  after_create :backend
  enum status: {cancel: -1,}
  STATUS = {cancel: -1, waiting: 0, confirm: 1, finish: 2}

  def course
    Sku.find_by(sku: sku)
  end

  private

  def backend
    case status
      when STATUS[:cancel]
      when STATUS[:waiting]
      when STATUS[:confirm]
        lesson.update(used: (lesson.used + amount)) if status.eql?(STATUS[:confirm])
        sku_course = Sku.find_by(sku: sku)
        course = sku_course.course
        if course.guarantee.eql?(Course::GUARANTEE)
          service = coach.service
          wallet = Wallet.find_or_create_by(user: service)
          #购买时课程单价
          wallet.with_lock do
            wallet.balance += (sku_course.selling_price * amount)
            wallet.action = WalletLog::ACTIONS['卖课收入']
            wallet.save
          end
        end
        MessageJob.perform_later(user.id, MESSAGE['消课'] % [sku_course.course_name, created_at.strftime('%Y%m%d')+'%05d' % id])
        SmsJob.perform_later(lesson.order.contact_phone, SMS['消课'], [sku_course.course_name, created_at.strftime('%Y%m%d')+'%05d' % id])
      when STATUS[:finish]

    end
  end
end

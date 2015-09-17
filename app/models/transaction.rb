class Transaction < ActiveRecord::Base
  SOURCE ={alipay: '支付宝', jd: '京东', webchat: '微信'}
  validates_uniqueness_of :no, scope: :source
  after_create :update_order

  def source_key
    SOURCE.key(source)
  end

  private
  def update_order
    order = Order.find_by(no: order_no)
    order.update(status: Order::STATUS[:pay], pay_type: Order::PAY_TYPE[source_key]) if order.pay_amount.eql?(price)
  end
end

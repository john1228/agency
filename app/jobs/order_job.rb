class OrderJob < ActiveJob::Base
  queue_as :default

  def perform(order_id)
    order = Order.find_by(id: order_id)
    order.update(status: Order::STATUS[:cancel]) if order.status.eql?(Order::STATUS[:unpaid])
  end
end

class OrdersController < ApplicationController
  layout 'admin'

  def index
    date = Date.new(params[:year], params[:month]) rescue Date.today
    @day = []
    stored_order = []
    measured_order = []
    clocked_order = []
    course_order = []
    (date.at_beginning_of_month..date.at_end_of_month).each { |current_date|
      @day << current_date.day
      stored_order << Order.joins(:order_item)
                          .where(
                              service_id: current_user.all_services.pluck(:id),
                              updated_at: current_date..current_date.tomorrow,
                              order_items: {
                                  type: 1
                              }
                          )
      measured_order << Order.joins(:order_item)
                            .where(
                                service_id: current_user.all_services.pluck(:id),
                                updated_at: current_date..current_date.tomorrow,
                                order_items: {
                                    type: 2
                                }
                            )
      clocked_order << Order.joins(:order_item)
                           .where(
                               service_id: current_user.all_services.pluck(:id),
                               updated_at: current_date..current_date.tomorrow,
                               order_items: {
                                   type: 3
                               }
                           )
      course_order << Order.joins(:order_item)
                          .where(
                              service_id: current_user.all_services.pluck(:id),
                              updated_at: current_date..current_date.tomorrow,
                              order_items: {
                                  type: 4
                              }
                          )
    }
    @order = [
        {name: '储值卡', data: stored_order.map { |item| item.count }},
        {name: '次卡', data: measured_order.map { |item| item.count }},
        {name: '时效卡', data: clocked_order.map { |item| item.count }},
        {name: '课程卡', data: course_order.map { |item| item.count }}
    ].to_json
    @sale = [
        {name: '储值卡', data: stored_order.map { |item| item.sum(:total).to_i }},
        {name: '次卡', data: measured_order.map { |item| item.sum(:total).to_i }},
        {name: '时效卡', data: clocked_order.map { |item| item.sum(:total).to_i }},
        {name: '课程卡', data: course_order.map { |item| item.sum(:total).to_i }}
    ].to_json

    @orders = Order
                  .where(service_id: current_user.all_services.pluck(:id), updated_at: date.at_beginning_of_month..date.at_end_of_month)
                  .order(updated_at: :desc)
                  .paginate(page: params[:page]||1, per_page: 10)
  end
end

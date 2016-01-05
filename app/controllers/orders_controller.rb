class OrdersController < ApplicationController
  layout 'admin'

  def index
    date = Date.new(params[:year], params[:month]) rescue Date.today
    @day = []
    stored_order = []
    measured_order = []
    clocked_order = []
    course_order = []
    (date.at_beginning_of_month..date.at_end_of_month).each { |date|
      @day << date
      stored_order << Order.joins(:order_item)
                          .where(
                              service_id: current_user.all_services.pluck(:id),
                              updated_at: date..date.tomorrow,
                              order_items: {
                                  type: 1
                              }
                          ).count
      measured_order << Order.joins(:order_item)
                            .where(
                                service_id: current_user.all_services.pluck(:id),
                                updated_at: date..date.tomorrow,
                                order_items: {
                                    type: 1
                                }
                            ).count
      clocked_order << Order.joins(:order_item)
                           .where(
                               service_id: current_user.all_services.pluck(:id),
                               updated_at: date..date.tomorrow,
                               order_items: {
                                   type: 1
                               }
                           ).count
      course_order << Order.joins(:order_item)
                          .where(
                              service_id: current_user.all_services.pluck(:id),
                              updated_at: date..date.tomorrow,
                              order_items: {
                                  type: 1
                              }
                          ).count
    }
    @data = [
        {name: '储值卡', data: stored_order},
        {name: '次卡', data: measured_order},
        {name: '时效卡', data: clocked_order},
        {name: '私教卡', data: course_order}
    ].to_json
    @orders = Order
                  .where(service_id: current_user.all_services.pluck(:id), updated_at: date.at_beginning_of_month..date.at_end_of_month)
                  .order(updated_at: :desc)
                  .paginate(page: params[:page]||1, per_page: 10)
  end
end

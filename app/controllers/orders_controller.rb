class OrdersController < ApplicationController
  layout 'admin'

  def index
    filter = {}
    filter[:order_items] = {sku: params[:sku]} if params[:sku].present?
    filter[:coach_id] = params[:coach] if params[:coach].present?
    date = Date.today
    @day = []
    @s_order = []
    @c_order = []
    (date.at_beginning_of_month..date.at_end_of_month).each { |everyday|
      @day << everyday.day
      @s_order << rand(1000)
      @c_order << rand(100)
    }
    @orders = Order.joins(:order_item).where(service_id: current_user.all_services.pluck(:id), updated_at: date.at_beginning_of_month..date.at_end_of_month).where(filter).order(updated_at: :desc).paginate(page: params[:page]||1, per_page: 10)
  end
end

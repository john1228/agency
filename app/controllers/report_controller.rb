class ReportController < ApplicationController
  layout 'admin'

  def course
    @skus = Sku.where(seller_id: @service.coaches.pluck(:id) << @service.id).pluck(:sku, :course_name)
    @coaches = @service.coaches.pluck(:id, 'profiles.name')
    @year = Date.today.year
    @month = Date.today.month
  end


  def order
    filter = {}
    filter[:order_items] = {sku: params[:sku]} if params[:sku].present?
    filter[:coach_id] = params[:coach] if params[:coach].present?
    date = Date.new(params[:year].to_i, params[:month].to_i)
    @day = []
    @s_order = []
    @c_order = []
    (date.at_beginning_of_month..date.at_end_of_month).each { |everyday|
      @day << everyday.day
      @s_order << Order.joins(:order_item).where(service_id: @service.id, updated_at: everyday.at_beginning_of_day..everyday.at_end_of_day).where(filter).count
      @c_order << Order.joins(:order_item).where(coach_id: @service.coaches.pluck(:id), updated_at: everyday.at_beginning_of_day..everyday.at_end_of_day).where(filter).count
    }
    @orders = Order.joins(:order_item).where(updated_at: date.at_beginning_of_month..date.at_end_of_month).paginate(page: params[:page]||1, per_page: 1)
    render layout: false
  end

  def order_table
    filter = {}
    filter[:order_items] = {sku: params[:sku]} if params[:sku].present?
    filter[:coach_id] = params[:coach] if params[:coach].present?
    date = Date.new(params[:year].to_i, params[:month].to_i)
    @orders = Order.joins(:order_item).where(order_items: {sku: sku},
                                             service_id: @service.id,
                                             updated_at: date.at_beginning_of_month..date.at_end_of_month).paginate(page: params[:page]||1, per_page: 1)
    respond_to do |format|
      format.html
      format.js
    end
  end


  def appointment
    filter = {}
    filter[:sku] = params[:sku] if params[:sku].present?
    filter[:coach_id] = params[:coach] if params[:coach].present?
    date = Date.new(params[:year].to_i, params[:month].to_i)
    @day = []
    @appointment = []
    (date.at_beginning_of_month..date.at_end_of_month).each { |everyday|
      @day << everyday.day
      @appointment << Appointment.where(coach_id: @service.coaches.pluck(:id), created_at: everyday.at_beginning_of_day..everyday.at_end_of_day).where(filter).count
    }
    @appointments = Appointment.where(coach_id: @service.coaches.pluck(:id), created_at: date.at_beginning_of_day..date.at_end_of_day).where(filter).order(id: :desc).paginate(page: params[:page]||1, per_page: 1)
    render layout: false
  end

  def appointment_table
    filter = {}
    filter[:order_item] = {sku: sku} if params[:sku].present?
    filter[:coach_id] = {sku: sku} if params[:coach].present?
    date = Date.new(params[:year].to_i, params[:month].to_i)
    @appointments = Appointment.where(coach_id: @service.coaches.pluck(:id), sku: sku, created_at: date.at_beginning_of_month..date.at_end_of_month).where(filter).order(id: :desc).paginate(page: params[:page]||1, per_page: 1)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def sale
    filter = {}
    filter[:order_item] = {sku: sku} if params[:sku].present?
    filter[:coach_id] = {sku: sku} if params[:coach].present?
    date = Date.new(params[:year].to_i, params[:month].to_i)
    @day = []
    @s_sale = []
    @c_sale = []
    (date.at_beginning_of_month..date.at_end_of_month).each { |everyday|
      @day << everyday.day
      @s_sale << (Order.joins(:order_item).where(order_items: {sku: sku}, service_id: @service.id, updated_at: everyday.at_beginning_of_day..everyday.at_end_of_day).where(filter).sum(:total)).to_i
      @c_sale << (Order.joins(:order_item).where(order_items: {sku: sku}, coach_id: @service.coaches.pluck(:id), updated_at: everyday.at_beginning_of_day..everyday.at_end_of_day).where(filter).sum(:total)).to_i
    }
    @orders = Order.joins(:order_item).where(order_items: {sku: sku},
                                             service_id: @service.id,
                                             updated_at: date.at_beginning_of_month..date.at_end_of_month).where(filter).paginate(page: params[:page]||1, per_page: 1)
    render layout: false
  end

  def sale_table
    filter = {}
    filter[:order_item] = {sku: sku} if params[:sku].present?
    filter[:coach_id] = {sku: sku} if params[:coach].present?
    date = Date.new(params[:year].to_i, params[:month].to_i)
    @orders = Order.joins(:order_item).where(service_id: @service.id,
                                             updated_at: date.at_beginning_of_month..date.at_end_of_month).where(filter).paginate(page: params[:page]||1, per_page: 1)
    respond_to do |format|
      format.html
      format.js
    end
  end
end

class ReportController < ApplicationController
  layout 'admin'

  def course
    @skus = Sku.where(seller_id: @service.coaches.pluck(:id) << @service.id).pluck(:sku, :course_name)
    @sku = @skus.first[0] rescue '0'
    @year = Date.today.year
    @month = Date.today.month
  end


  def order
    sku = params[:sku]||(Sku.where(seller_id: @service.coaches.pluck(:id) << @service.id).first.sku rescue '')
    date = Date.new(params[:year].to_i, params[:month].to_i)
    @day = []
    @s_order = []
    @c_order = []
    (date.at_beginning_of_month..date.at_end_of_month).each { |everyday|
      @day << everyday.day
      @s_order << Order.joins(:order_item).where(order_items: {sku: sku}, service_id: @service.id, updated_at: everyday.at_beginning_of_day..everyday.at_end_of_day).count
      @c_order << Order.joins(:order_item).where(order_items: {sku: sku}, coach_id: @service.coaches.pluck(:id), updated_at: everyday.at_beginning_of_day..everyday.at_end_of_day).count
    }
    @orders = User.paginate(page: params[:page]||1, per_page: 1)
    @orders = Order.joins(:order_item).where(order_items: {sku: sku},
                                             service_id: @service.id,
                                             updated_at: date.at_beginning_of_month..date.at_end_of_month).paginate(page: params[:page]||1, per_page: 1)
    render layout: false
  end

  def order_table
    sku = params[:sku]
    date = Date.new(params[:year].to_i, params[:month].to_i) rescue Date.today
    @orders = Order.joins(:order_item).where(order_items: {sku: sku},
                                             service_id: @service.id,
                                             updated_at: date.at_beginning_of_month..date.at_end_of_month).paginate(page: params[:page]||1, per_page: 1)
    respond_to do |format|
      format.html
      format.js
    end
  end


  def appointment
    sku = params[:sku]||(Sku.where(seller_id: @service.coaches.pluck(:id) << @service.id).first.sku rescue '')
    date = Date.new(params[:year].to_i, params[:month].to_i)
    @day = []
    @appointment = []
    (date.at_beginning_of_month..date.at_end_of_month).each { |everyday|
      @day << everyday.day
      @appointment << Appointment.where(coach_id: @service.coaches.pluck(:id), sku: sku, created_at: everyday.at_beginning_of_day..everyday.at_end_of_day).count
    }
    @appointments = Appointment.where(coach_id: @service.coaches.pluck(:id), sku: sku, created_at: date.at_beginning_of_day..date.at_end_of_day).order(id: :desc).paginate(page: params[:page]||1, per_page: 1)
    render layout: false
  end

  def appointment_table
    sku = params[:sku]
    date = Date.new(params[:year].to_i, params[:month].to_i) rescue Date.today
    @appointments = Appointment.where(coach_id: @service.coaches.pluck(:id), sku: sku, created_at: date.at_beginning_of_month..date.at_end_of_month).order(id: :desc).paginate(page: params[:page]||1, per_page: 1)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def sale
    sku = params[:sku]||(Sku.where(seller_id: @service.coaches.pluck(:id) << @service.id).first.sku rescue '')
    date = Date.new(params[:year].to_i, params[:month].to_i)
    @day = []
    @s_sale = []
    @c_sale = []
    (date.at_beginning_of_month..date.at_end_of_month).each { |everyday|
      @day << everyday.day
      @s_sale << (Order.joins(:order_item).where(order_items: {sku: sku}, service_id: @service.id, updated_at: everyday.at_beginning_of_day..everyday.at_end_of_day).sum(:total)).to_i
      @c_sale << (Order.joins(:order_item).where(order_items: {sku: sku}, coach_id: @service.coaches.pluck(:id), updated_at: everyday.at_beginning_of_day..everyday.at_end_of_day).sum(:total)).to_i
    }
    @orders = Order.joins(:order_item).where(order_items: {sku: sku},
                                             service_id: @service.id,
                                             updated_at: date.at_beginning_of_month..date.at_end_of_month).paginate(page: params[:page]||1, per_page: 1)
    render layout: false
  end

  def sale_table
    sku = params[:sku]
    date = Date.new(params[:year].to_i, params[:month].to_i) rescue Date.today
    @orders = Order.joins(:order_item).where(order_items: {sku: sku},
                                             service_id: @service.id,
                                             updated_at: date.at_beginning_of_month..date.at_end_of_month).paginate(page: params[:page]||1, per_page: 1)
    respond_to do |format|
      format.html
      format.js
    end
  end


  def coach
    @coaches = @service.coaches.pluck(:id, 'profiles.name')
    @coach = @service.coaches.first.id rescue 0
    @year = Date.today.year
    @month = Date.today.month
  end
end

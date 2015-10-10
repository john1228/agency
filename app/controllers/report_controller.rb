class ReportController < ApplicationController
  layout 'admin'

  def course
    @skus = Sku.where(seller_id: @service.coaches.pluck(:id) << @service.id).pluck(:sku, :course_name)
    sku = params[:sku] || @skus.first[0]
    @date = Date.new((params[:year]||Date.today.year).to_i, (params[:month]||Date.today.month).to_i)
    @days = []
    @all = []
    @coach = []
    @appointment = []
    (@date.at_beginning_of_month..@date.at_end_of_month).each { |day|
      @days << day.day
      @all << Order.joins(:order_item).where(order_items: {sku: sku}, status: Order::STATUS[:pay], updated_at: day.at_beginning_of_day..day.at_end_of_day).count
      @coach << Order.joins(:order_item).where(order_items: {sku: sku}, status: Order::STATUS[:pay], updated_at: day.at_beginning_of_day..day.at_end_of_day).count
      @appointment << Appointment.where(sku: sku, created_at: day.at_beginning_of_day..day.at_end_of_day).count
    }

    @orders = Order.joins(:order_item).where(order_items: {sku: sku}, status: Order::STATUS[:pay], updated_at: @date.at_beginning_of_day..@date.at_end_of_day).paginate(page: params[:page]||1, per_page: 1)
    @appointments = Appointment.where(sku: sku, updated_at: @date.at_beginning_of_day..@date.at_end_of_day).order(id: :desc).paginate(page: params[:page]||1, per_page: 1)
    respond_to do |format|
      format.html
      format.json { render json: {day: @days, all: @all, coach: @coach} }
    end

  end

  def coach
    @coaches = @service.coaches.pluck(:id, 'profiles.name')
    @date = Date.new((params[:year]||Date.today.year).to_i, (params[:month]||Date.today.month).to_i)
    @days = []
    @coach = []
    @appointment = []
    (@date.at_beginning_of_month..@date.at_end_of_month).each { |day|
      @days << day.day
      if params[:coach].blank?
        @all << Order.where(service_id: @service.id, status: Order::STATUS[:pay], updated_at: day.at_beginning_of_day..day.at_end_of_day).count
        @coach << Order.where(service_id: @service.id, status: Order::STATUS[:pay], updated_at: day.at_beginning_of_day..day.at_end_of_day).count
        @appointment << Appointment.where(coach_id: @service.coaches.pluck(:id), created_at: day.at_beginning_of_day..day.at_end_of_day).count
      else
        @all << Order.joins(:order_item).where(order_items: {sku: params[:sku]}, status: Order::STATUS[:pay], updated_at: day.at_beginning_of_day..day.at_end_of_day).count
        @coach << Order.joins(:order_item).where(order_items: {sku: params[:sku]}, status: Order::STATUS[:pay], updated_at: day.at_beginning_of_day..day.at_end_of_day).count
        @appointment << Appointment.where(sku: params[:sku], created_at: day.at_beginning_of_day..day.at_end_of_day).count
      end

      @coach << rand(count)
      @appointment << rand(count)
    }

    @orders = Order.where(service_id: @service.id, status: Order::STATUS[:online]).paginate(page: params[:page]||1, per_page: 1)
    @appointments = Appointment.where(coach: @service.coaches).paginate(page: params[:page]||1, per_page: 1)

    respond_to do |format|
      format.html
      format.json { render json: {day: @days, all: @all, coach: @coach} }
    end

  end
end

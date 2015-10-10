class ReportController < ApplicationController
  layout 'admin'

  def course
    @skus = Sku.where(seller_id: @service.coaches.pluck(:id) << @service.id).pluck(:sku, :course_name)
    sku = (params[:sku] || @skus.first[0]) rescue ''
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
    coach = (params[:coach]||@coaches.first[0]) rescue 0
    @date = Date.new((params[:year]||Date.today.year).to_i, (params[:month]||Date.today.month).to_i)
    @days = []
    @coach = []
    @appointment = []
    (@date.at_beginning_of_month..@date.at_end_of_month).each { |day|
      @days << day.day
      @coach << Order.where(coach_id: coach, status: Order::STATUS[:pay], updated_at: day.at_beginning_of_day..day.at_end_of_day).count
      @appointment << Appointment.where(coach_id: coach, created_at: day.at_beginning_of_day..day.at_end_of_day).count
    }

    @orders = Order.where(coach_id: coach, status: Order::STATUS[:online]).paginate(page: params[:page]||1, per_page: 1)
    @appointments = Appointment.where(coach_id: coach).paginate(page: params[:page]||1, per_page: 1)

    respond_to do |format|
      format.html
      format.json { render json: {day: @days, all: @all, coach: @coach} }
    end

  end
end

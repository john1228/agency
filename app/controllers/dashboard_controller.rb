class DashboardController < ApplicationController
  layout 'admin'

  def index
    @date = Date.new((params[:year]||Date.today.year).to_i, (params[:month]||Date.today.month).to_i)
    @days = []
    @all = []
    @coach = []
    (@date.at_beginning_of_month..@date.at_end_of_month).each { |day|
      @days << day.day
      @all << Order.where(service_id: @service.id, updated_at: day.at_beginning_of_day..day.at_end_of_day).count
      @coach << Order.where(coach_id: @service.coaches.pluck(:id), updated_at: day.at_beginning_of_day..day.at_end_of_day).count
    }
    respond_to do |format|
      format.html
      format.json { render json: {day: @days, all: @all, coach: @coach} }
    end
  end
end

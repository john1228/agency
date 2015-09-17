class DashboardController < ApplicationController
  layout 'login'

  def index
    @date = Date.today
    @days = []
    @all = []
    @coach = []
    (@date.at_beginning_of_month..@date.at_end_of_month).each { |day|
      count = rand(100)
      @days << day.day
      @all << count #Order.where(service_id: @service.id, status: Order::STATUS[:pay], updated_at: day.at_beginning_of_day..day.at_end_of_day).count
      @coach << rand(count)
    }
  end
end

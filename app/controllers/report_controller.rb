class ReportController < ApplicationController
  layout 'login'

  def index
    @date = Date.today
    @days = []
    @all = []
    @coach = []
    @appointment = []
    (@date.at_beginning_of_month..@date.at_end_of_month).each { |day|
      count = rand(100)
      @days << day.day
      @all << count #Order.where(service_id: @service.id, status: Order::STATUS[:pay], updated_at: day.at_beginning_of_day..day.at_end_of_day).count
      @coach << rand(count)
      @appointment << rand(count)
    }

    @orders = Order.where(service_id: @service.id, status: Order::STATUS[:online]).paginate(page: params[:page]||1, per_page: 1)
    @appointments = Appointment.where(coach: @service.coaches).paginate(page: params[:page]||1, per_page: 1)
  end

  def coach
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


  def order
    @date = Date.today
    @days = []
    @all = []
    @coach = []
    (@date.at_beginning_of_month..@date.at_end_of_month).each { |day|
      count = rand(100)
      @days << day.day
      @all << count #服务号总订单数量
      @coach << rand(count) #服务号私教订单数量
    }
    render layout: false
  end

  def appointment
    @date = Date.today
    @days = []
    @appointment = []
    (@date.at_beginning_of_month..@date.at_end_of_month).each { |day|
      @days << day.day
      @appointment << rand(100)
    }
    render layout: false
  end

  def coach
    @date = Date.today
    @days = []
    @all = []
    @coach = []
    (@date.at_beginning_of_month..@date.at_end_of_month).each { |day|
      count = rand(100)
      @days << day.day
      @all << count #服务号总订单金额
      @coach << rand(count) #服务号私教订单金额
    }
    render layout: false
  end
end

class StudentsController < ApplicationController
  layout 'login'

  def index
    @follows = Follow.includes(:user).where(service_id: @service.id).uniq(:user_id).paginate(page: params[:page]||1, per_page: 1)
    @orders = Order.includes(:user).where(service_id: @service.id).uniq(:user_id).paginate(page: params[:page]||1, per_page: 1)
  end
end

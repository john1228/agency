class WithdrawsController < ApplicationController
  layout 'admin'

  def index
    @withdraws = Withdraw.where(coach_id: current_user.all_services.pluck(:id)).order(id: :desc).paginate(page: params[:page]||1, per_page: 10)
  end
end

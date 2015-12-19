class TransfersController < ApplicationController
  layout 'admin'

  def index
    @transfers = Transerfer.where(coach_id: current_user.all_services.pluck(:id)).order(id: :desc).paginate(page: params[:page]||1, per_page: 10)
  end

  def create
    
  end
end

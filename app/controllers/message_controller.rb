class MessageController < ApplicationController
  layout 'admin'

  def index
    @mass_messages = MassMessage.where(service_id: current_user.all_services.pluck(:id)).order(id: :desc).paginate(page: params[:page]||1, per_page: 10)
  end

  def new
    @groups = MassMessageGroup.where(service_id: @service.id)
    @mass_message = MassMessage.new
    @success = params[:success]
  end

  def create
    PushMessageJob.perform_later(@service.profile.mxid, params[:group], params[:content])
    MassMessage.create(service_id: @service.id, user_id: params[:group], content: params[:content])
    redirect_to action: :new, success: true
  end
end

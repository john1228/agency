class MessageController < ApplicationController
  layout 'login'

  def index
  end

  def new
    @groups = MassMessageGroup.where(service_id: @service.id).pluck(:id, :name)
    @mass_message = MassMessage.new
  end

  def create
  end
end

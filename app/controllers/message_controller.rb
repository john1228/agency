class MessageController < ApplicationController
  layout 'admin'

  def index
  end

  def new
    @groups = MassMessageGroup.where(service_id: @service.id)
    @mass_message = MassMessage.new
  end

  def create
  end
end

class DynamicsController < ApplicationController
  layout 'login'

  def index
    @dynamics = @service.dynamics.paginate(page: params[:page]||1, per_page: 1)
  end

  def new
    @dynamic = @service.dynamics.new
  end

  def create
    dynamic = @service.dynamics.new(params[:dynamic])
    if dynamic.save
    else
    end
  end

  def destroy
    @result = false
    dynamic = @service.dynamics.find_by(id: params[:id])
    @result = true if dynamic.destroy
  end
end

class DynamicsController < ApplicationController
  layout 'login'

  def index
    @dynamics = @service.dynamics.paginate(page: params[:page]||1, per_page: 1)
  end

  def new
    @dynamic = @service.dynamics.new
  end

  def create
    @dynamic = @service.dynamics.new(dynamic_params)
    if @dynamic.save
      @success = '发布动态成功'
    else
      @error = '发布动态失败'
    end
    render action: :new
  end

  def destroy
    @result = false
    dynamic = @service.dynamics.find_by(id: params[:id])
    @result = true if dynamic.destroy
  end

  private
  def dynamic_params
    images = params[:image][0, 6].map { |image| {image: image} }
    params[:dynamic][:images_attributes] = images
    params.require(:dynamic).permit(:content, images_attributes: [:image])
  end
end

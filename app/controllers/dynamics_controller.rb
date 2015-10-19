class DynamicsController < ApplicationController
  layout 'admin'

  def index
    @dynamics = @service.dynamics.paginate(page: params[:page]||1, per_page: 3)
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

  def show
    
  end

  def destroy
    @result = false
    dynamic = @service.dynamics.find_by(id: params[:id])
    @result = true if dynamic.destroy
    redirect_to action: :index
  end

  private
  def dynamic_params
    if params[:image].present?
      params[:dynamic][:images_attributes] = params[:image]
    elsif params[:film].present?
      params[:dynamic][:images_attributes][:film] = params[:film]
      params[:dynamic][:images_attributes][:cover] = params[:cover]
    end
    params.require(:dynamic).permit(:content, images_attributes: [:image], film_attributes: [:film, :cover])
  end
end

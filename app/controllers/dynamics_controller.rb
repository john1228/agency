class DynamicsController < ApplicationController
  layout 'admin'
  before_filter :load_services

  def index

    @dynamics = Dynamic.where(:user_id=>@services.map(&:id)).order(id: :desc).paginate(page: params[:page]||1, per_page: 24)
    respond_to do |format|
      format.html #default : index.html.erb
      format.js # default : index.js.erb
    end
  end

  def new
    @dynamic = Dynamic.new
  end

  def create
    dynamic = Dynamic.new(dynamic_params)
    if dynamic.save
      @success = true
      @dynamic = Dynamic.new
    else
      @errors = dynamic.errors
      @dynamic = dynamic
    end
    render action: :new
  end

  def show
    @dynamic = Dynamic.where(:user_id=>@services.map(&:id)).find_by(id: params[:id])
  end

  def destroy
    result = false
    dynamic = @service.dynamics.find_by(id: params[:id])
    result = true if dynamic.destroy
    render json: {result: result}
  end

  private
  def dynamic_params
    if params[:image].present?
      params[:dynamic][:images_attributes] = params[:image].map { |image| {image: image} }
    elsif params[:film].present?
      params[:dynamic][:film_attributes] = {
          film: params[:film],
          cover: params[:cover]
      }
    end
    params.require(:dynamic).permit(:user_id,:content, images_attributes: [:image], film_attributes: [:film, :cover])
  end

  def load_services
    @services = current_user.all_services
  end
end

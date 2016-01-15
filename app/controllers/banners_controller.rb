class BannersController < ApplicationController
  layout 'admin'

  def index
    @banners = STBanner.where(service_id: current_user.all_service.pluck(:id)).paginate(page: params[:page]||1, per_page: 10)
  end
end

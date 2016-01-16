class SBannersController < ApplicationController
  layout 'admin'

  def index
    @banners = SBanner.where(service_id: current_user.all_services.pluck(:id)).paginate(page: params[:page]||1, per_page: 10)
  end

  def new
    @banner = SBanner.new(pos_1: Array.new(3), pos_2: Array.new(3), pos_3: Array.new(3))
  end

  def create
    @banner = SBanner.new(banner_params)
    if @banner.save
      redirect_to s_banners_path, flash: {success: '添加终端机展示图成功'}
    else
      render action: :new,flash: {danger: '添加终端机图失败'}
    end
  end

  protected
  def banner_params
    params.require(:s_banner).permit(:service_id, :title, pos_1: [], pos_2: [], pos_3: [])
  end
end

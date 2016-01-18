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
      render action: :new
    end
  end

  def edit
    @banner = SBanner.find(params[:id])
  end

  def update
    @banner = SBanner.find(params[:id])
    if @banner.update(banner_params)
      redirect_to s_banners_path, flash: {success: '更新终端机展示图成功'}
    else
      render action: :edit
    end
  end

  def destroy
    banner = SBanner.find(params[:id])
    if banner.destroy
      redirect_to s_banners_path, flash: {success: '删除成功'}
    else
      redirect_to s_banners_path, flash: {dangers: '删除失败'}
    end
  end


  protected
  def banner_params
    params.require(:s_banner).permit(:service_id, :title, pos_1: [], pos_2: [], pos_3: [])
  end
end

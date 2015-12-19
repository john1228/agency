class SkusController < ApplicationController
  layout 'admin'

  def index
    @query = Sku.card.online.where(:service_id => current_user.client_id).ransack(params[:q])
    @sku = @query.result.paginate(page: params[:page]||1, per_page: 5).order("updated_at desc")
  end

  def new
    @sku = Sku.new
    @sku.build_production
  end

  def create
    @sku = Sku.new(create_params)
    if @sku.save
    else
    end
  end

  def edit
    @sku = Sku.find(params[:id])
  end

  def update

  end

  private
  def create_params

  end

  def update_params

  end
end

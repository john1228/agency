class ProductsController < ApplicationController
  layout 'admin'

  def index
    @query = Product.joins(:sku).where(skus: {sku_type: Sku.sku_types[:card], service_id: current_user.all_services.pluck(:id)}).ransack(params[:q])
    @products = @query.result.paginate(page: params[:page]||1, per_page: 5).order("created_at desc")
  end

  def new
    @product = Product.new
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

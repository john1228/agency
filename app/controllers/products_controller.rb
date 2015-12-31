class ProductsController < ApplicationController
  layout 'admin'

  def index
    @query = Product.joins(:sku).where(skus: {sku_type: Sku.sku_types[:card], service_id: current_user.all_services.pluck(:id)}).ransack(params[:q])
    @products = @query.result.paginate(page: params[:page]||1, per_page: 5).order("created_at desc")
  end

  def new
    @product = Product.new
    @product.image = Array.new(6)
    @product.build_card_type(card_type: params[:card_type].to_i)
    if @product.card_type.coach?
      @product.build_prop
    end
  end

  def create
    @product = Product.new(create_params)
    if @product.save
      redirect_to action: :index
    else
      @card_type = params[:card_type].to_i
      render action: :new
    end
  end

  def edit
    @sku = Sku.find(params[:id])
  end

  def update
  end


  private
  def create_params
    params.require(:product).permit(:service_id, :card_type_id, :name, :description, :special, :market_price, :selling_price, :store, :limit, image: [])
  end

  def update_params

  end
end

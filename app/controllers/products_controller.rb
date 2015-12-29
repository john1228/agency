class ProductsController < ApplicationController
  layout 'admin'

  def index
    @query = Product.joins(:sku).where(skus: {sku_type: Sku.sku_types[:card], service_id: current_user.all_services.pluck(:id)}).ransack(params[:q])
    @products = @query.result.paginate(page: params[:page]||1, per_page: 5).order("created_at desc")
  end

  def new
    @product = Product.new
    @product.image = Array.new(6)
    @card_type = params[:card_type].to_i
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


  def card_types
    @membership_card_types = MembershipCardType.where(card_type: params[:type], service_id: params[:service_id])
    render json: @membership_card_types.map { |card_type|
             card_type.as_json(only: [:id, :name, :count, :price, :valid_days, :latest_delay_days])
           }
  end

  private
  def create_params
    params.require(:product).permit(:service_id, :type, :name, :description, :special, :market_price, :selling_price, :store, :limit, image: [])
  end

  def update_params

  end
end

class ProductsController < ApplicationController
  layout 'admin'

  def index
    @query = Product.ransack(name_cont: params[:name])
    @list = params[:list]||'online'
    case params[:list]
      when 'online'
        @products = @query.result.joins(:sku).where(skus: {service_id: current_user.all_services.pluck(:id), status: 1}).paginate(page: params[:page]||1, per_page: 10).order("created_at desc")
      when 'offline'
        @products = @query.result.joins(:sku).where(skus: {service_id: current_user.all_services.pluck(:id), status: 0}).paginate(page: params[:page]||1, per_page: 10).order("created_at desc")
      else
        @products = @query.result.joins(:sku).where(skus: {service_id: current_user.all_services.pluck(:id), status: 1}).paginate(page: params[:page]||1, per_page: 10).order("created_at desc")
    end
  end

  def new
    @product = Product.new
    @product.image = Array.new(6)
    @product.build_card_type(card_type: params[:card_type].to_i)
    if @product.card_type.course?
      @product.build_prop
    end
  end

  def create
    @product = Product.new(create_params)
    if @product.save
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit
    @sku = Sku.find(params[:id])
  end

  def online
    product = Product.find_by(id: params[:id])
    if product.sku.online!
      render json: {code: 1}
    else
      render json: {code: 0}
    end
  end

  def offline
    product = Product.find_by(id: params[:id])
    if product.sku.offline!
      render json: {code: 1}
    else
      render json: {code: 0}
    end
  end


  private
  def create_params
    params.require(:product).permit(:service_id, :card_type_id, :name, :description, :special, :market_price, :selling_price, :store, :limit, image: [])
  end

  def update_params
  end
end

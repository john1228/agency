class ProductsController < ApplicationController
  layout 'admin'

  def index
    @query = Product.ransack(name_cont: params[:name])
    @list = params[:list]||'online'
    case params[:list]
      when 'online'
        @products = @query.result.joins(:sku).where(skus: {
                                                        service_id: params[:service].blank? ? current_user.all_services.pluck(:id) : params[:service],
                                                        status: 1,
                                                        course_type: params[:card_type].blank? ? Sku.course_types.values : params[:card_type]
                                                    })
                        .order("created_at desc")
                        .paginate(page: params[:page]||1, per_page: 10)
      when 'offline'
        @products = @query.result.joins(:sku).where(skus: {
                                                        service_id: params[:service].blank? ? current_user.all_services.pluck(:id) : params[:service],
                                                        status: 0,
                                                        course_type: params[:card_type].blank? ? Sku.course_types.values : params[:card_type]
                                                    })
                        .order("created_at desc")
                        .paginate(page: params[:page]||1, per_page: 10)
      else
        @products = @query.result.joins(:sku).where(skus: {
                                                        service_id: params[:service].blank? ? current_user.all_services.pluck(:id) : params[:service],
                                                        status: 1,
                                                        course_type: params[:card_type].blank? ? Sku.course_types.values : params[:card_type]
                                                    })
                        .order("created_at desc")
                        .paginate(page: params[:page]||1, per_page: 10)
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
      redirect_to products_path, flash: {success: "上架成功"}
    else
      redirect_to products_path, flash: {danger: "上架失败"}
    end
  end

  def offline
    product = Product.find_by(id: params[:id])
    if product.sku.offline!
      redirect_to products_path, flash: {success: "下架成功"}
    else
      redirect_to products_path, flash: {danger: "下架成功"}
    end
  end


  def destroy
    product = Product.find(params[:id])
    if product.sku.deleted!
      redirect_to products_path, flash: {success: "删除成功"}
    else
      redirect_to products_path, flash: {danger: "删除失败"}
    end
  end

  private
  def create_params
    params.require(:product).permit(:service_id, :card_type_id, :name,
                                    :description, :special, :market_price,
                                    :selling_price, :store, :limit,
                                    prop_attributes: [:during, :proposal, :style], image: [])
  end

  def update_params
  end
end

class MembershipCardTypesController < InheritedResources::Base
  layout "admin"

  def index
    @query_result = MembershipCardType.where(service_id: current_user.all_services.pluck(:id)).ransack(params[:q])
    @membership_card_types = @query_result.result.paginate(page: params[:page]||1, per_page: 8).order("updated_at desc")
  end

  def new
    @membership_card_type = MembershipCardType.new(card_type: params[:card_type].to_i)
  end

  def create
    @membership_card_type = MembershipCardType.new(cart_params)
    @membership_card_type.client_id = current_user.client_id
    if @membership_card_type.save
      @success = true
      flash[:success] = "成功创建会员卡种类"
      redirect_to membership_card_types_path
    else
      #flash[:error] = "xxx"
      render :new
    end
  end

  def update
    @membership_card_type = MembershipCardType.find(params[:id])
    if @membership_card_type.update(cart_params)
      @success = true
      flash[:success] = "成功更新会员卡种类"
      redirect_to membership_card_types_path
    else
      render :edit
    end
  end

  private
  def cart_params
    params.require(:membership_card_type).permit(:name,
                                                 :service_id,
                                                 :client_id,
                                                 :card_type,
                                                 :price,
                                                 :value,
                                                 :days,
                                                 :remark,
                                                 :has_valid_extend_information,
                                                 :valid_days,
                                                 :delay_days)
  end
end


class MembershipCardTypesController < InheritedResources::Base
  layout "admin"

  def index
    @q = MembershipCardType.where(:client_id => current_user.client_id).ransack(params[:q])
    @membership_card_types = @q.result.paginate(page: params[:page]||1, per_page: 5).order("updated_at desc")
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

  def cards
    membership_card_types = MembershipCardType.all #MembershipCardType.where(card_type: params[:type], service_id: params[:service_id])
    render json: {
               cards: membership_card_types.map { |card_type|
                 card_type.as_json(only: [:id, :name, :price, :valid_days, :latest_delay_days])
               }
           }
  end

  private
  def cart_params
    params.require(:membership_card_type).permit(:name, :service_id, :client_id, :card_type, :price, :count, :days, :remark, :has_valid_extend_information, :valid_days, :latest_delay_days)
  end
end


class MembershipCardAbstractsController < InheritedResources::Base
  layout "admin"

  def index

    @q = MembershipCardAbstract.where(:client_id => current_user.client_id).ransack(params[:q])
    @membership_card_abstracts = @q.result.paginate(page: params[:page]||1, per_page: 5).order("updated_at desc")

  end

  def create
    @membership_card_abstract = MembershipCardAbstract.new(membership_card_abstract_params)
    @membership_card_abstract.client_id = current_user.client_id
    if @membership_card_abstract.save
      @success = true
      flash[:success] = "成功创建会员卡种类"
      redirect_to membership_card_abstracts_path
    else
      #flash[:error] = "xxx"
      render :new
    end
  end

  private

    def membership_card_abstract_params
      params.require(:membership_card_abstract).permit(:name, :service_id, :client_id, :card_type, :price, :count, :days, :remark,:has_valid_extend_information, :valid_days, :latest_delay_days)
    end
end


class MembershipCardAbstractsController < InheritedResources::Base
  layout "admin"

  def index

    @q = MembershipCardAbstract.where(:client_id => current_user.client_id).ransack(params[:q])
    @membership_card_abstracts = @q.result.paginate(page: params[:page]||1, per_page: 5).order("updated_at desc")

  end

  private

    def membership_card_abstract_params
      params.require(:membership_card_abstract).permit(:name, :service_id, :client_id, :card_type, :price, :count, :days, :has_valid_extend_information, :valid_days, :latest_delay_days)
    end
end


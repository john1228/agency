class MembershipCardLogsController < ApplicationController
  layout 'admin'

  def index
    @membership_card = MemberShipCard.find(params[:membership_card_id])
    @logs = @membership_card.logs.paginate(page: params[:page]||1, per_page: 10)
  end
end

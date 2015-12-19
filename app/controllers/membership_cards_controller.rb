class MembershipCardsController < ApplicationController
  def index
    @q = MembershipCard.where(:client_id => current_user.client_id).ransack(params[:q])
    @membership_cards = @q.result.paginate(page: params[:page]||1, per_page: 5).order("updated_at desc")
  end
end

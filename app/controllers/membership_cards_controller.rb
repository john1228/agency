class MembershipCardsController < ApplicationController
  layout 'admin'

  def index
    @query = MembershipCard.where(:client_id => current_user.id).ransack(params[:query])
    @membership_cards = @query.result.paginate(page: params[:page]||1, per_page: 10).order("updated_at desc")
  end

  def new
    @membership_card = MembershipCard.new(client_id: current_user.id, card_type: params[:type].to_i)
    @membership_card.logs.build
  end

  def create
  end
end

class MembershipCardsController < ApplicationController
  layout 'admin'

  def index
    members = Member.where(client_id: current_user.client_id).ransack(name_or_mobile_con: params[:name_or_mobile])
    @query = MembershipCard.where(member_id: members.result.pluck(:id)).ransack(card_type_eq: params[:card_type], service_id: params[:service])
    @membership_cards = @query.result.includes(:member).paginate(page: params[:page]||1, per_page: 10).order("updated_at desc")
  end

  def new
    @membership_card = MembershipCard.new(client_id: current_user.id, card_type: params[:card_type].to_i)
    @membership_card.logs.build
    logger.info "<<#{@membership_card.card_type}"
  end

  def create
    @membership_card = MembershipCard.new(membership_card_params)
    @membership_card.logs.build(membership_card_log_params)
    if @membership_card.save
      redirect_to membership_cards_path
    else
      render action: :new
    end
  end


  def edit

  end

  def update

  end

  protected
  def membership_card_params
    params.require(:membership_card).permit(:card_type, :service_id, :member_id, :name, :value, :valid_start, :valid_end, :physical_card)
  end

  def membership_card_log_params
    params.permit(:change_amount, :pay_amount, :pay_type, :seller, :remark)
  end
end

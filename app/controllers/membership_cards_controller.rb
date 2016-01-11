class MembershipCardsController < ApplicationController
  layout 'admin'

  def index
    members = Member.where(client_id: current_user.client_id).ransack(name_or_mobile_cont: params[:name_or_mobile])
    @query = MembershipCard.ransack(card_type_eq: params[:card_type], service_id_eq: params[:service])
    @membership_cards = @query.result.includes(:member).where(member: members.result).paginate(page: params[:page]||1, per_page: 10).order("updated_at desc")
  end

  def new
    @membership_card = MembershipCard.new(client_id: current_user.id, card_type: params[:card_type].to_i)
    @membership_card.logs.build
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

  def active
    membership_card = MembershipCard.find_by(id: params[:id])
    membership_card.open = Date.today
    if membership_card.active!
      redirect_to action: :index, flash: "激活成功"
    else
      redirect_to action: :index, error: "激活失败"
    end
  end

  def disable
    membership_card = MembershipCard.find_by(id: params[:id])
    if membership_card.disable!
      redirect_to action: :index, flash: "停用成功"
    else
      redirect_to action: :index, error: "停用失败"
    end
  end

  def transfer
    membership_card = MembershipCard.find_by(id: params[:id])
    if membership_card.update(transfer_params)
      redirect_to action: :index, flash: "转卡成功"
    else
      redirect_to action: :index, error: "转卡失败"
    end
  end

  def transfer_member
    @membership_card = MembershipCard.find_by(id: params[:id])
    @members = Member.where(service_id: @membership_card.service_id).map { |member|
      ["#{member.name}(#{member.mobile})", member.id]
    }
    render layout: false
  end


  protected
  def membership_card_params
    params.require(:membership_card).permit(:card_type, :service_id, :member_id, :name, :value, :valid_days, :delay_days, :physical_card)
  end

  def membership_card_log_params
    params.permit(:change_amount, :pay_amount, :pay_type, :seller, :remark)
  end

  def transfer_params
    params.permit(:member_id, :physical_card)
  end
end

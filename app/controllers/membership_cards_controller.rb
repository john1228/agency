class MembershipCardsController < ApplicationController
  layout 'admin'

  def index
    flash[:success] = params[:success]
    flash[:danger] = params[:error]
    members = Member.ransack(name_or_mobile_cont: params[:name_or_mobile])
    @query = MembershipCard.ransack(card_type_eq: params[:card_type], service_id_eq: params[:service])
    @membership_cards = @query.result.includes(:member)
                            .where(member_id: members.result.where(service_id: current_user.all_services.pluck(:id)))
                            .order("updated_at desc")
                            .paginate(page: params[:page]||1, per_page: 10)
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
      redirect_to action: :index, success: "激活成功"
    else
      redirect_to action: :index, error: "激活失败"
    end
  end

  def disable
    membership_card = MembershipCard.find_by(id: params[:id])
    if membership_card.disable!
      redirect_to action: :index, success: "停用成功"
    else
      redirect_to action: :index, error: "停用失败"
    end
  end

  def transfer
    membership_card = MembershipCard.find_by(id: params[:id])
    if membership_card.update(transfer_params)
      redirect_to action: :index, success: "转卡成功"
    else
      redirect_to action: :index, error: "转卡失败:#{membership_card.errors.messages.values.joins(';')}"
    end
  end

  def transfer_member
    @membership_card = MembershipCard.find_by(id: params[:id])
    @members = Member.where(service_id: @membership_card.service_id).map { |member|
      ["#{member.name}(#{member.mobile})", member.id]
    }
    render layout: false
  end


  def binding_request
    @membership_card = MembershipCard.find_by(id: params[:id])
    render action: :binding, layout: false
  end

  def binding_confirm
    membership_card = MembershipCard.find_by(id: params[:id])
    if membership_card.update(binding_params)
      redirect_to action: :index, success: '绑定实体卡成功'
    else
      redirect_to action: :index, error: '绑定实体卡失败'
    end
  end

  def charge_request
    @membership_card = MembershipCard.find_by(id: params[:id])
    @seller = AdminUser.where(service_id: @membership_card.service_id).sale.map { |user| [user.name, user.name] }
    render action: :charge, layout: false
  end

  def charge_confirm
    membership_card = MembershipCard.find_by(id: params[:id])
    membership_card.logs.build(charge_log_params)
    if membership_card.course?
      membership_card.supply_value = membership_card.supply_value.to_i + params[:change_amount].to_i
      membership_card.open = Date.today
      membership_card.valid_days = params[:valid_days].to_i
    elsif membership_card.stored? || membership_card.measured?
      membership_card.value = membership_card.value.to_i + params[:change_amount].to_i
      membership_card.open = Date.today
      membership_card.valid_days = params[:valid_days].to_i
    elsif membership_card.clocked?
      if membership_card.valid_end.eql?('已过期')
        membership_card.value = params[:change_amount]
        membership_card.open = Date.today
      else
        membership_card.value = (membership_card.valid_end - Date.today).floor + params[:change_amount].to_i
        membership_card.open = Date.today
      end
    end
    if membership_card.save
      redirect_to action: :index, success: '充值成功'
    else
      redirect_to action: :index, error: '充值失败'
    end
  end


  protected
  def membership_card_params
    params.require(:membership_card).permit(:card_type, :service_id, :member_id, :name, :value, :valid_days, :delay_days, :physical_card)
  end

  def membership_card_log_params
    params.permit(:change_amount, :pay_amount, :pay_type, :seller, :remark)
  end

  def transfer_params
    {
        member_id: params[:member],
        physical_card: params[:physical_card]
    }
  end

  def binding_params
    params.permit(:physical_card)
  end

  def charge_log_params
    params.permit(:change_amount, :pay_amount, :seller, :pay_type).merge(operator: current_user.name, remark: '美型平台充值', action: 'charge')
  end
end

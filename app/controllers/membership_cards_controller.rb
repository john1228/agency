class MembershipCardsController < ApplicationController
  layout 'admin'

  def index
    members = Member.ransack(name_or_mobile_cont: params[:name_or_mobile])
    @query = MembershipCard.ransack(card_type_eq: params[:card_type])
    @membership_cards = @query.result.includes(:member)
                            .where(member_id: members.result.where(service_id: params[:service].blank? ? current_user.all_services.pluck(:id) : params[:service]))
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
      flash[:success] = "激活成功"
      redirect_to action: :index
    else
      flash[:danger] = "激活失败:"+ membership_card.errors.messages.values.join(';')
      redirect_to action: :index
    end
  end

  def disable
    membership_card = MembershipCard.find_by(id: params[:id])
    if membership_card.disable!
      flash[:success] = "停用成功"
      redirect_to action: :index
    else
      flash[:danger] = "停用失败:"+ membership_card.errors.messages.values.join(';')
      redirect_to action: :index
    end
  end

  def transfer
    membership_card = MembershipCard.find_by(id: params[:id])
    if membership_card.logs.checkin.pending.present?
      flash[:danger] = "转卡失败:该卡还有未处理的簽到记录"
      redirect_to action: :index
    else
      if membership_card.update(transfer_params)
        flash[:success] = "转卡成功"
        redirect_to action: :index
      else
        flash[:danger]= "转卡失败:"+ membership_card.errors.messages.values.join(';')
        redirect_to action: :index
      end
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
      flash[:success] = "绑定实体卡成功"
      redirect_to action: :index, flash: {success: '绑定实体卡成功'}
    else
      flash[:danger] = '绑定实体卡失败:' + membership_card.errors.messages.values.join(';')
      redirect_to action: :index
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
      membership_card.status = 'normal'
    elsif membership_card.stored? || membership_card.measured?
      membership_card.value = membership_card.value.to_i + params[:change_amount].to_i
      membership_card.open = Date.today
      membership_card.valid_days = params[:valid_days].to_i
      membership_card.status = 'normal'
    elsif membership_card.clocked?
      if membership_card.valid_end.eql?('已过期')
        membership_card.value = params[:change_amount]
      else
        membership_card.value = (membership_card.valid_end - Date.today).floor + params[:change_amount].to_i
      end
      membership_card.open = Date.today
      membership_card.status = 'normal'
    end
    if membership_card.save
      flash[:success]= '充值成功'
      redirect_to action: :index
    else
      flash[:danger] = "充值失败"
      redirect_to action: :index
    end
  end


  protected
  def membership_card_params
    params.require(:membership_card).permit(:card_type, :service_id, :member_id, :name, :value, :valid_days, :delay_days, :physical_card, :created_at)
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

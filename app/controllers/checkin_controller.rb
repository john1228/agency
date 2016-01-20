class CheckinController < ApplicationController
  layout 'admin'

  def index
    @member = Member.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:member])
    @members = Member.where.not(member_type: Member.member_types['coach'])
                   .where(service_id: current_user.all_services.pluck(:id)).map { |member|
      ["#{member.name}(#{member.mobile})", member.id]
    }
    @cards = MembershipCard.where(member: @member)
  end

  def pending
    @members = Member.where.not(member_type: Member.member_types['coach'])
                   .where(service_id: current_user.all_services.pluck(:id)).map { |member|
      ["#{member.name}(#{member.mobile})", member.id]
    }
    member = Member.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:member])
    if member.present?
      cards = member.cards.where(service_id: current_user.all_services.pluck(:id))
      membership_card_ids = cards.pluck(:id)
      physical_cards = cards.pluck(:physical_card)
      physical_cards.compact!
      if physical_cards.present?
        @logs = MembershipCardLog.checkin.pending.where("membership_card_id IN (?) OR entity_number IN (?)", membership_card_ids, physical_cards)
                    .where(service_id: current_user.all_services.pluck(:id))
                    .order(created_at: :desc)
                    .paginate(page: params[:page]||1, per_page: 10)
      else
        @logs = MembershipCardLog.checkin.pending.where(membership_card_id: membership_card_ids)
                    .where(service_id: current_user.all_services.pluck(:id))
                    .order(created_at: :desc)
                    .paginate(page: params[:page]||1, per_page: 10)
      end
    else
      @logs = MembershipCardLog.checkin.pending
                  .where(service_id: current_user.all_services.pluck(:id))
                  .order(created_at: :desc)
                  .paginate(page: params[:page]||1, per_page: 10)
    end
  end

  def confirm
    @members = Member.where.not(member_type: Member.member_types['coach'])
                   .where(service_id: current_user.all_services.pluck(:id)).map { |member|
      ["#{member.name}(#{member.mobile})", member.id]
    }
    member = Member.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:member])
    if member.present?
      cards = member.cards.where(service_id: current_user.all_services.pluck(:id))
      @logs = MembershipCardLog.checkin.where(status: [MembershipCardLog.statuses[:confirm], MembershipCardLog.statuses[:cancel]])
                  .where(membership_card_id: cards.pluck(:id))
                  .where(service_id: current_user.all_services.pluck(:id))
                  .order(created_at: :desc)
                  .paginate(page: params[:page]||1, per_page: 10)

    else
      @logs = MembershipCardLog.checkin.where(status: [MembershipCardLog.statuses[:confirm], MembershipCardLog.statuses[:cancel]])
                  .where(service_id: current_user.all_services.pluck(:id))
                  .order(updated_at: :desc)
                  .paginate(page: params[:page]||1, per_page: 10)
    end
  end

  def membership_card_list
    @checkin = MembershipCardLog.checkin.pending.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:id])
    if @checkin.membership_card.present?
      @cards = [@checkin.membership_card]
    else
      @cards = MembershipCard.where(physical_card: @checkin.entity_number, service_id: current_user.all_services.pluck(:id)).find_all { |membership_card|
        if membership_card.course?
          membership_card.supply_value > 0 && (membership_card.to_be_activated? || membership_card.normal?)&& !membership_card.valid_end.eql?('已过期')
        else
          membership_card.value > 0 && (membership_card.to_be_activated? || membership_card.normal?) && !membership_card.valid_end.eql?('已过期')
        end
      }
    end
    render layout: false
  end


  def checkin_new
    @membership_card = MembershipCard.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:id])
    if @membership_card.present?
      if @membership_card.valid_end.eql?('已过期')
        render text: "该会员卡已经过期"
      else
        if @membership_card.course?
          remain_value = @membership_card.supply_value
        else
          remain_value = @membership_card.value
        end
        if remain_value > 0
          render layout: false
        else
          render text: "该会员卡内余额不足"
        end
      end
    else
      render text: "无效的会员卡签到"
    end
  end

  def checkin_create
    membership_card = MembershipCard.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:id])
    if membership_card.present?
      if membership_card.valid_end.eql?('已过期')
        flash[:danger] = "该会员卡已经过期"
        redirect_to checkin_path
      else
        if membership_card.course?
          remain_value = membership_card.supply_value
        else
          remain_value = membership_card.value
        end
        if remain_value > 0
          checkin = membership_card.logs.checkin.create(
              service_id: membership_card.service_id,
              change_amount: params[:change_amount],
              operator: current_user.name,
              remark: 'SAAS后台手动签到'
          )
          if checkin.may_confirm?
            checkin.confirm!
            flash[:success] = "签到成功"
            redirect_to checkin_path
          else
            flash[:danger] = "签到确认失败"
            redirect_to checkin_path
          end
        else
          flash[:danger] = "该会员卡内余额不足"
          redirect_to checkin_path
        end
      end
    else
      flash[:danger] = "无效的会员卡签到"
      redirect_to checkin_path
    end
  end


  def update
    if params[:membership_card_id].present?
      checkin = MembershipCardLog.checkin.pending.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:id])
      if checkin.present?
        checkin.membership_card_id = params[:membership_card_id]
        checkin.change_amount = params["value_#{params[:membership_card_id]}".to_sym]
        checkin.operator = current_user.name
        if checkin.may_confirm?
          checkin.confirm!
          flash[:success] = "确认成功"
          redirect_to action: :pending
        else
          flash[:danger] = "确认失败: 卡余额不足或者消课数量为0"
          redirect_to action: :pending
        end
      else
        flash[:danger] = "确认失败: 该信息已经处理"
        redirect_to action: :pending
      end
    else
      flash[:danger] = "确认失败: 请选择要确认的会员卡"
      redirect_to action: :pending
    end

  end

  def ignore
    checkin = MembershipCardLog.checkin.pending.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:id])
    if checkin.ignore!
      flash[:success] = "忽略成功"
      redirect_to action: :pending
    else
      flash[:danger] = "忽略失败"
      redirect_to action: :pending
    end
  end

  def cancel
    checkin = MembershipCardLog.checkin.confirm.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:id])
    if checkin.cancel!
      flash[:success] = "取消成功"
      redirect_to action: :confirm
    else
      flash[:danger] = "取消失败"
      redirect_to action: :confirm
    end
  end
end

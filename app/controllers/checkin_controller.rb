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
    flash[:success] = params[:success]
    flash[:danger] = params[:error]
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
      @cards = MembershipCard.where.not(status: MembershipCard.statuses['disable'])
                   .where(physical_card: @checkin.entity_number, service_id: current_user.all_services.pluck(:id))
    end
    render layout: false
  end

  def update
    checkin = MembershipCardLog.checkin.pending.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:id])
    checkin.membership_card_id = params[:membership_card_id]
    checkin.change_amount = params["value_#{params[:membership_card_id]}".to_sym]
    checkin.operator = current_user.name
    if checkin.may_confirm?
      checkin.confirm!
      redirect_to action: :pending, success: '确认成功'
    else
      redirect_to action: :pending, error: '确认失败: 卡余额不足或者消课数量为0'
    end
  end

  def ignore
    checkin = MembershipCardLog.checkin.pending.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:id])
    if checkin.ignore!
      redirect_to action: :pending, success: '忽略成功'
    else
      redirect_to action: :pending, error: '忽略失败'
    end
  end

  def cancel
    checkin = MembershipCardLog.checkin.confirm.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:id])
    if checkin.cancel!
      redirect_to action: :confirm, success: '取消成功'
    else
      redirect_to action: :confirm, error: '取消失败'
    end
  end
end

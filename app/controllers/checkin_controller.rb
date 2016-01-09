class CheckinController < ApplicationController
  layout 'admin'

  def index
    @member = Member.where(client_id: current_user.client_id).find_by(id: params[:member])
    @members = Member.where.not(member_type: Member.member_types['coach'])
                   .where(client_id: current_user.client_id).map { |member|
      ["#{member.name}(#{member.mobile})", member.id]
    }
    @cards = MembershipCard.where(member: @member)
  end

  def pending
    @flash = params[:flash]
    @error = params[:error]
    @members = Member.where.not(member_type: Member.member_types['coach'])
                   .where(client_id: current_user.client_id).map { |member|
      ["#{member.name}(#{member.mobile})", member.id]
    }
    member = Member.where(client_id: current_user.client_id).find_by(id: params[:member])
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
                   .where(client_id: current_user.client_id).map { |member|
      ["#{member.name}(#{member.mobile})", member.id]
    }
    member = Member.where(client_id: current_user.client_id).find_by(id: params[:member])
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
      @cards = MembershipCard.where(physical_card: @checkin.entity_number, service_id: current_user.all_services.pluck(:id))
    end
    render layout: false
  end

  def update
    check_in = MembershipCardLog.checkin.pending.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:id])
    check_in.membership_card_id = params[:membership_card_id]
    check_in.change_amount = params["value_#{params[:membership_card_id]}".to_sym]
    check_in.operator = current_user.name
    if check_in.confirm!
      redirect_to action: :pending, flash: '确认成功'
    else
      redirect_to action: :pending, error: '确认失败'
    end
  end

  def ignore
    check_in = MembershipCardLog.checkin.pending.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:id])
    if check_in.ignore!
      redirect_to action: :index, flash: '忽略成功'
    else
      redirect_to :index, error: '忽略失败'
    end
  end

  def cancel
    check_in = MembershipCardLog.checkin.confirm.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:id])
    if check_in.cancel!
      redirect_to action: :confirm, flash: '取消成功'
    else
      redirect_to action: :confirm, error: '取消失败'
    end
  end
end

class CheckinController < ApplicationController
  layout 'admin'

  def index
    @member = Member.where(client_id: current_user.client_id).find_by(id: params[:member])
    @members = Member.full.where(client_id: current_user.client_id).pluck(:name, :id)
    @cards = MembershipCard.where(member: @member)
  end

  def pending
    @members = Member.full.where(client_id: current_user.client_id).pluck(:name, :id)
    @cards = MembershipCard.where(member: @member)
    @logs = MembershipCardLog.checkin.pending
                .where(service_id: current_user.all_services.pluck(:id))
                .order(id: :desc)
                .paginate(page: params[:page]||1, per_page: 10)
  end

  def confirm
    @members = Member.full.where(client_id: current_user.client_id).pluck(:name, :id)
    @cards = MembershipCard.where(member: @member)
    @logs = MembershipCardLog.checkin.where.not(status: 'pending')
                .where(service_id: current_user.all_services.pluck(:id))
                .order(id: :desc)
                .paginate(page: params[:page]||1, per_page: 10)
  end

  def membership_card_list
    checkin = MembershipCardLog.checkin.pending.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:id])
    if checkin.membership_card.present?
      @cards = [checkin.membership_card]
    else
      @cards = MembershipCard.where(physical_card: checkin.entity_number, service_id: current_user.all_services.pluck(:id))
    end
  end

  def update
    @check_in = MembershipCardLog.checkin.pending.where(service_id: current_user.all_services.pluck(:id)).find_by(id: params[:id])
    if @check_in.update(update_params)
      redirect_to :index, flash: '确认成功'
    else
      redirect_to :index, flash: '确认失败'
    end
  end

  protected
  def update_params
    params.permit(:check_in).permit(:membership_card_id, :change_amount)
  end

end

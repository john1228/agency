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

  def create

  end
end

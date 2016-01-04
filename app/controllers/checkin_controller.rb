class CheckinController < ApplicationController
  layout 'admin'

  def index
    @member = Member.where(client_id: current_user.client_id).find_by(id: params[:member])
    @members = Member.full.where(client_id: current_user.client_id).pluck(:name, :id)
    @cards = MembershipCard.where(member: @member)
  end

  def list
    @members = Member.full.where(client_id: current_user.client_id).pluck(:name, :id)
    @cards = MembershipCard.where(member: @member)
    @logs = MembershipCardLog.checkin
                .where(membership_card_id: MembershipCard.where(member_id: Member.full.where(client_id: current_user.client_id).pluck(:id)).pluck(:id))
                .paginate(page: params[:page]||1, per_page: 20)
  end

  def create

  end
end

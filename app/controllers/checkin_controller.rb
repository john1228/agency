class CheckinController < ApplicationController
  layout 'admin'

  def index
    @member = Member.where(client_id: current_user.client_id).find_by(id: params[:member])
    @members = Member.full.where(client_id: current_user.client_id).pluck(:name, :id)
    @cards = MembershipCard.where(member: @member)
  end

  def list

  end
end

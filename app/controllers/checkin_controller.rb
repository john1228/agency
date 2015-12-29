class CheckinController < ApplicationController
  layout 'admin'

  def index
    @member = Member.where(client_id: current_user.id).find_by(id: params[:id])
    @members = Member.where(client_id: current_user.id).pluck(:name, :id)
    @cards = MembershipCard.where(member: @member).paginate(page: params[:page]||1, per_page: 5).order('id desc')
  end

  def list

  end
end

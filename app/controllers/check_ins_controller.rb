class CheckInsController < ApplicationController
  layout 'admin'

  def index
    member = Member.find_by(mobile: params[:mobile])
    cards = MemberShipCard
  end

  def list

  end
end

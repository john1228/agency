class DashboardController < ApplicationController
  layout 'admin'

  def index
    #TODO: 引入真实數據
    authorize! :read, current_user
    @service = current_user.all_services.includes(:profile).pluck('profiles.name')
    @member = current_user.all_services.includes(:profile).map { |service|
      [service.profile.name, service.members.count] }
    @transaction = current_user.all_services.includes(:profile).map { |service| [
        service.profile.name, service.orders.sum(:total).floor] }
    @incoming = current_user.all_services.includes(:profile).map { |service| service.orders.sum(:total).floor }
    respond_to do |format|
      format.html
    end
  end
end

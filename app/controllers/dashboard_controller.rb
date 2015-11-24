class DashboardController < ApplicationController
  layout 'admin'

  def index
    #TODO: 引入真实數據
    authorize! :read, current_user
    @service = current_user.all_services.map { |service| service.profile.name }
    @member = current_user.all_services.map { |service| [service.profile.name, rand(35)] }
    @transaction = current_user.all_services.map { |service| [service.profile.name, rand(35)] }
    @incoming = current_user.all_services.map { |service| rand(1000) }

    respond_to do |format|
      format.html
    end
  end
end

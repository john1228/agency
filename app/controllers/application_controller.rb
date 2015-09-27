class ApplicationController < ActionController::Base
  before_filter :authenticate_admin_user!

  before_filter :find_manager_service
  
  protected
  def find_manager_service
    @service = Service.first if admin_user_signed_in?
  end

  def after_sign_in_path_for(admin_user)
    dashboard_path
  end
end

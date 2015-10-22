class ApplicationController < ActionController::Base
  before_filter :authenticate_admin_user!
  before_filter :find_manager_service

  protected
  def find_manager_service
    @service = Service.find_by(id: current_admin_user.service_id) if admin_user_signed_in?
  end

  def after_sign_in_path_for(admin_user)
    dashboard_path
  end

  def after_sign_out_path_for(admin_user)
    new_admin_user_session_path
  end
end

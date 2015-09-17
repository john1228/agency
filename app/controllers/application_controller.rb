class ApplicationController < ActionController::Base
  before_action :auth
  private
  def auth
    @service = Service.first
  end
end

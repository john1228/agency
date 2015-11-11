class UserRegistrationsController < InheritedResources::Base

  private

    def user_registration_params
      params.require(:user_registration).permit(:reg_type, :avatar, :name, :gender, :service_id, :client_id, :mobile, :source, :birthday, :address, :remark)
    end
end


class ProfilesController < ApplicationController
  layout 'admin'

  def show
    @profile = @service.profile
  end

  def edit
    @profile = @service.profile # Profile.find_by(user_id: @service.id)
  end

  def update
    if @service.profile.update(profile_params)
      @success = true
    else
      @success = false
    end
    redirect_to action: :show
  end

  def password

  end

  def change_password
    redirect_to action: :password
  end

  def profile_params
    params.require(:profile).permit(:name, :avatar, :province, :city, :address, :mobile, :signature, hobby: [], service: [])
  end
end

class ProfileController < ApplicationController
  layout 'admin'

  def show
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
    params[:profile_attributes] = {
        name: params[:name],
        avatar: params[:avatar],
        interests: params[:interests],
        service: params[:service],
        signature: params[:signature],
        address: (params[:province] + params[:city] + params[:area] + params[:address]).gsub('', '').gsub('', ''),
        mobile: params[:mobile]
    }
    params.require(:profile_attributes).permit(:name, :avatar, :signature, :address, :mobile, :interests, service: [])
  end
end

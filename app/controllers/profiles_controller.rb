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

  def photowall
    @photowall = @service.photos
  end

  def update_photowall
    params.each { |k, v|
      if k.include?('photo')
        id = k.split('_')[1]
        if id.eql?('0')
          @service.photos.create(photo: v)
        else
          @service.photos.find_by(id: id).update(photo: v)
        end
      end
    }
    redirect_to action: :show
  end

  def showtime
    @showtime = @service.showtime
  end

  def update_showtime
    @service.dynamics.create(top: 1, content: params[:content], film_attributes: [{title: params[:title], cover: params[:cover], film: params[:film]}])
    redirect_to action: :show
  end

  private
  def profile_params
    params.require(:profile).permit(:name, :avatar, :province, :city, :address, :mobile, :signature, hobby: [], service: [])
  end
end

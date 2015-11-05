class ServicesController < InheritedResources::Base
  layout "admin"
  def index
    puts 3
  end

  def show
    if params[:id].nil?
      render :index
      return
    else
      super
    end
  end

  def new
    @service = Service.new
    @service.profile = Profile.new
    super
  end

  def create
    @service = Service.new(service_params)
    @service.profile.identity = 2
    @service.client_id = current_user.client_id
    @service.sns = SecureRandom.hex
    if @service.save
      @success = true
      flash[:success] = "成功创建门店"
      redirect_to services_path
    else
      #flash[:error] = "xxx"
      render :new
    end
  end

  private
    def service_params
      params[:service] ||= {}
      params[:service][:profile_attributes][:province] = params[:province]
      params[:service][:profile_attributes][:city] = params[:city]

      if params[:image].present?
        params[:service][:photos_attributes] = params[:image].map { |image| {photo: image} }
      end

      params.require(:service).permit(:mobile, :password, profile_attributes:
                                               [:avatar, :name, :gender, :address, :birthday, :signature, :province, :city, :identity,
                                                :business_hour_start, :business_hour_end, :mobile, hobby: []], photos_attributes:[:photo])


    end



end

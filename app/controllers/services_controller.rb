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
      flash.success = "成功创建门店"
      redirect_to :index
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
      params.require(:service).permit(:mobile, :password, profile_attributes:
                                               [:avatar, :name, :gender, :address, :birthday, :signature, :province, :city, :identity, hobby: []])

    end



end

class ServicesController < InheritedResources::Base
  layout "admin"

  def index
    @services = current_user.all_services.paginate(page: params[:page]||1, per_page: 5).order("updated_at desc")
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

  def update
    @service = Service.find(params[:id])
    @service.assign_attributes(service_params)
    @service.profile.identity = 2
    @service.client_id = current_user.client_id
    @service.sns = SecureRandom.hex
    if @service.save
      @success = true
      flash[:success] = "成功修改门店"
      redirect_to services_path
    else
      #flash[:error] = "xxx"
      render :edit
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
                                               [:id, :avatar, :name, :gender, :address, :birthday, :signature, :province, :city, :identity,
                                                :business_hour_start, :business_hour_end, :mobile, hobby: []], photos_attributes: [:photo])


  end
end

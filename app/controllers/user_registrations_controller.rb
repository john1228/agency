class UserRegistrationsController < InheritedResources::Base
  layout "admin"

  def index

    @q = UserRegistration.ransack(params[:q])
    @user_registrations = @q.result.paginate(page: params[:page]||1, per_page: 5).order("updated_at desc")

  end

  def create
    @user_registration = UserRegistration.new(user_registration_params)
    @user_registration.client_id = current_user.client_id
    if @user_registration.save
      @success = true
      flash[:success] = "成功创建会员"
      redirect_to services_path
    else
      #flash[:error] = "xxx"
      render :new
    end
  end
  
  def update
    @user_registration = UserRegistration.find(params[:id])
    @user_registration.assign_attributes(service_params)
    @user_registration.client_id = current_user.client_id
    if @user_registration.save
      @success = true
      flash[:success] = "成功修改会员"
      redirect_to services_path
    else
      #flash[:error] = "xxx"
      render :edit
    end
  end

  private

    def user_registration_params
      params.require(:user_registration).permit(:reg_type, :avatar, :name, :gender, :service_id, :client_id, :mobile, :source, :birthday, :address, :remark)
    end
end


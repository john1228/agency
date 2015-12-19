class UserRegistrationsController < InheritedResources::Base
  layout "admin"

  def index
    @q = UserRegistration.where(:client_id => current_user.client_id).ransack(params[:q])
    @user_registrations = @q.result.paginate(page: params[:page]||1, per_page: 5).order("updated_at desc")
    @member = [['准会员', rand(1000)], ['会员', rand(5000)]]
  end

  def create
    result, @user_registration = UserRegistration.create_from_input(user_registration_params, current_user.client_id)

    if result
      @success = true
      flash[:success] = "成功创建会员"
      redirect_to user_registrations_path
    else
      #flash[:error] = "xxx"
      render :new
    end
  end

  def update
    @user_registration = UserRegistration.find(params[:id])
    @user_registration.assign_attributes(user_registration_params)
    if @user_registration.save
      @success = true
      flash[:success] = "成功修改会员"
      redirect_to user_registrations_path
    else
      #flash[:error] = "xxx"
      render :edit
    end
  end

  private

  def user_registration_params
    params.require(:user_registration).permit(:reg_type, :avatar, :name, :gender, :service_id, :client_id, :mobile, :source, :birthday, :address, :remark,
                                              :province, :city)
  end
end


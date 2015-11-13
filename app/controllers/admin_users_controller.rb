class AdminUsersController < InheritedResources::Base
  layout "admin"

  def index

    @q = AdminUser.where(:client_id => current_user.client_id).where("role > 4").ransack(params[:q])
    @admin_users = @q.result.paginate(page: params[:page]||1, per_page: 5).order("updated_at desc")

  end

  def create
    @admin_user = AdminUser.new(admin_user_params, current_user.client_id)

    if @admin_user.save
      @success = true
      flash[:success] = "成功创建工作人员"
      redirect_to admin_users_path
    else
      #flash[:error] = "xxx"
      render :new
    end
  end

  def update
    @admin_user = AdminUser.find(params[:id])
    @admin_user.assign_attributes(admin_user_params)
    if @admin_user.save
      @success = true
      flash[:success] = "成功创建工作人员"
      redirect_to admin_users_path
    else
      #flash[:error] = "xxx"
      render :edit
    end
  end

  private

  def admin_user_params
    fileds = [:reg_type, :avatar, :name, :gender, :service_id, :client_id, :mobile, :source, :birthday, :address, :remark,
        :province,:city]
    if params[:password].present?
      fileds << :password
    end
    params.require(:admin_user).permit(fileds)
  end
end


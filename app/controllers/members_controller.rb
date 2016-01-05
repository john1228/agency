class MembersController < InheritedResources::Base
  layout "admin"

  def index
    @query = Member.where(:client_id => current_user.client_id).where.not(member_type: Member.member_types['coach']).ransack(params[:q])
    @members = @query.result.paginate(page: params[:page]||1, per_page: 5).order("updated_at desc")
    @member = [['准会员', Member.associate.where(:client_id => current_user.client_id).count],
               ['会员', Member.full.where(:client_id => current_user.client_id).count]]
  end

  def create
    @member = Member.input.new(member_params)

    if @member.save
      @success = true
      flash[:success] = "成功创建会员"
      redirect_to members_path
    else
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

  def member_params
    params.require(:member).permit(:avatar, :name, :gender, :service_id, :client_id, :mobile, :source, :birthday, :address, :remark,
                                   :province, :city, :area)
  end
end


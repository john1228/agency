class MembersController < InheritedResources::Base
  layout "admin"

  def index
    @query = Member.ransack(params[:q])
    @members = @query.result.where(service_id: current_user.all_services.pluck(:id)).where.not(member_type: Member.member_types['coach']).paginate(page: params[:page]||1, per_page: 5).order("updated_at desc")
    @member = [['准会员', Member.associate.where(service_id: current_user.all_services.pluck(:id)).count],
               ['会员', Member.full.where(service_id: current_user.all_services.pluck(:id)).count]]
  end

  def create
    @member = Member.input.new(member_params)
    begin
      Member.transaction do
        user = User.find_by(mobile: @member.mobile)
        if user.blank?
          @member.build_user(mobile: @member.mobile, password: '12345678',
                             profile_attribtues: {
                                 name: @member.name,
                                 avatar: @member.avatar,
                                 gender: @member.gender,
                                 birthday: @member.birthday,
                                 province: @member.province,
                                 city: @member.city,
                                 area: @member.area,
                                 address: @member.address
                             })
        else
          @member.user_id = user.id
        end
        @member.save
      end
      flash[:success] = "成功创建会员"
      redirect_to members_path
    rescue Exception => exp
      flash[:danger] = ""
      render :new
    end
  end

  def update
    @member = Member.find(params[:id])
    @member.update(user_registration_params)
    if @member.update(member_params)
      flash[:success] = "修改会员成功"
      redirect_to user_registrations_path
    else
      flash[:danger] = "修改会员失败"
      render :edit
    end
  end

  private

  def member_params
    params.require(:member).permit(:avatar, :name, :gender, :service_id, :client_id, :mobile, :source, :birthday, :address, :remark,
                                   :province, :city, :area)
  end
end


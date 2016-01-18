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
    if @member.save
      redirect_to members_path, flash: {success: '创建会员成功'}
    else
      render :new
    end
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to members_path, flash: {success: '更新会员信息成功'}
    else
      render :edit
    end
  end

  private

  def member_params
    params.require(:member).permit(:avatar, :name, :gender, :service_id, :client_id, :mobile, :source, :birthday, :address, :remark,
                                   :province, :city, :area)
  end
end


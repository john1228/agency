class StudentsController < ApplicationController
  layout 'admin'

  def index
    @follows = Follow.where(service_id: @service.id).pluck(:user_id)||User.all.pluck(:id)
    @orders = Order.where(service_id: @service.id).pluck(:user_id)
    @users = User.where(id: (@follows + @orders).uniq).paginate(page: params[:page]||1, per_page: 10)
  end


  def group
    @follows = Follow.where(service_id: @service.id).pluck(:user_id)||User.all.pluck(:id)
    @orders = Order.where(service_id: @service.id).pluck(:user_id)
    @users = User.includes(:profile).where(id: (@follows + @orders).uniq)
    @groups = MassMessageGroup.where(service_id: @service.id)
  end

  def create_group
    MassMessageGroup.create(group_params.merge(service_id: @service.id))
  end

  def student
    @users = User.where(id: MassMessageGroup.find_by(params[:id]).user_id)
  end

  private
  def group_params
    params.permit(:name)
  end
end

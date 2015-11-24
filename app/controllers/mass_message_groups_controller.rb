class MassMessageGroupsController < ApplicationController
  layout 'admin'

  def index
  end

  def students
    order_users = User.pluck(:id)
    group_users = User.includes(:profile).where(id: MassMessageGroup.find_by(id: params[:id]).user_id)
    render json: {
               group: group_users.map { |user|
                 {
                     id: user.id,
                     name: user.profile.name,
                     gender: user.profile.gender.eql?(1) ? '女' : '男',
                     source: order_users.include?(user.id) ? '购买' : '关注'
                 }
               }
           }
  end

  def update
    group = MassMessageGroup.find_by(id: params[:id])
    if group.update(user_id: params[:user_id])
      render json: {code: 1}
    else
      render json: {code: 0}
    end
  end


  def create
    group = MassMessageGroup.new(name: params[:name], service_id: @service.id)
    if group.save
      render json: {code: 1, group: {id: group.id, name: group.name}}
    else
      render json: {code: 0}
    end

  end

  private
  def group_params
    params.permit(:user_id)
  end
end

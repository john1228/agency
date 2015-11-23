class MassMessage < ActiveRecord::Base
  belongs_to :service

  def groups
    MassMessageGroup.where(id: user_id).pluck(:name).join(',')
  end
end

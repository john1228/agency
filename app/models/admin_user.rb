#encoding : utf-8
class AdminUser < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :service #we may manage one service
  belongs_to :client


  enum gender: [:male, :female]
  enum role: [:super, :admin, :cms, :market, :operator, :superadmin, :sale, :front_desk, :finance, :store_manager, :store_admin]
  mount_uploader :avatar, PhotosUploader
  validates_presence_of :email, message: '邮箱必须输入'
  validates_presence_of :password, message: '密码必须输入'
  validates_presence_of :role, message: '身份必须选择'
  validates_presence_of :name, message: '名字必须输入', if: Proc.new { |user| user.sale? || user.front_desk? || user.finance? || user.store_manager? || user.store_admin? }
  validates_presence_of :service_id, message: '门店必须选择', if: Proc.new { |user| user.sale? || user.front_desk? || user.finance? || user.store_manager? || user.store_admin? }


  include AASM
  aasm :status do
    state :approving, :initial => true
    state :rejected
    state :approved

    event :reject do
      transitions :from => :approving, :to => :rejected
    end

    event :approve do
      transitions :from => :approving, :to => :approved
    end

  end

  def all_services
    if store_manager?||sale?||front_desk?||finance?||store_admin?
      Service.where(id: service_id)
    elsif super?||cms?||market?||operator?
      Service.all
    elsif superadmin?
      Service.where(client_id: id)
    end
  end
end

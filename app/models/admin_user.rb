#encoding : utf-8
class AdminUser < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :service #we may manage one service
  belongs_to :client
  include AASM

  ROLE = {super: 0, service: 1, cms: 2, market: 3, operator: 4}
  enum role: [ :super, :admin, :cms, :market, :operator, :superadmin, :sales, :front_desk, :finance, :store_manager,:store_admin ]



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
    services = Service.where(:client_id => self.client_id)
    if self.service.present?
      services = Service.where(:id=>self.service_id)
    end
    services
  end
  #benchmark :to_s
end

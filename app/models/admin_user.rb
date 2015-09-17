class AdminUser < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :service

  ROLE = {super: 0, service: 1, cms: 2, market: 3, operator: 4}
end

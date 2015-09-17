class Company < ActiveRecord::Base
  has_many :shops, class_name: CompanyShop, foreign_key: :shop_id, dependent: :destroy
  has_many :coaches, class_name: CompanyCoach, dependent: :destroy
end

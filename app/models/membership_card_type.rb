class MembershipCardType < ActiveRecord::Base
  enum card_type: [:stored, :measured, :clocked, :course]
  belongs_to :service
  has_many :products, foreign_key: :type
  validates :name, :service_id, :card_type, :price, :value, presence: true
  
  class << self
    def card_type_for_select
      card_types.map do |key, value|
        [I18n.t("enums.membership_card_type.card_type.#{key}"), value]
      end
    end
  end
end

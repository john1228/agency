class MembershipCardType < ActiveRecord::Base
  enum card_type: [:stored, :measured, :clocked]
  belongs_to :service
  has_many :products, foreign_key: :type

  class << self
    def card_type_for_select
      card_types.map do |key, value|
        [I18n.t("enums.membership_card_type.card_type.#{key}"), value]
      end
    end
  end
end

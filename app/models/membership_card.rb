class MembershipCard < ActiveRecord::Base
  enum card_type: [:stored, :measured, :clocked, :coach]
  enum pay_type: [:cash,:transfer,]
  belongs_to :member
  has_many :logs, class: MembershipCardLog, dependent: :destroy
  class << self
    def card_type_for_select
      card_types.map do |key, value|
        [I18n.t("enums.membership_card.card_type.#{key}"), value]
      end
    end
  end
end

class MembershipCard < ActiveRecord::Base
  enum card_type: [:stored, :measured, :clocked, :coach]
  enum status: [:to_be_activated, :normal, :disable]
  belongs_to :member
  belongs_to :service
  has_many :logs, class: MembershipCardLog, dependent: :destroy
  class << self
    def card_type_for_select
      card_types.map do |key, value|
        [I18n.t("enums.membership_card.card_type.#{key}"), value]
      end
    end
  end
end

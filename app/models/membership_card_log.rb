class MembershipCardLog < ActiveRecord::Base
  belongs_to :membership_card
  enum pay_type: [:mx, :cash, :card, :transfer, :other]
  enum action: [:buy, :transfer_card, :disable, :re_activated, :charge, :checkin, :cancel_checkin]
  enum status: [:pending, :confirm, :cancel]
  class << self
    def pay_type_for_select
      pay_types.keys.map do |key|
        [I18n.t("enums.membership_card_log.pay_type.#{key}"), key]
      end
    end
  end

  def member
    if membership_card.present?
      membership_card.member
    else
      MembershipCard.find_by(service_id: service_id, physical_card: entity_number)
    end
  end
end

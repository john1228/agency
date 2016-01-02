class MembershipCardLog < ActiveRecord::Base
  enum pay_type: [:mx, :cash, :card, :transfer, :other]
  enum action: [:buy, :transfer_card, :disable, :re_activated, :charge, :checkin, :cancel_checkin]
  class << self
    def pay_type_for_select
      pay_types.map do |key, value|
        [I18n.t("enums.membership_card_log.pay_type.#{key}"), value]
      end
    end
  end
end

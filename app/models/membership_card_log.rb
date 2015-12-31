class MembershipCardLog < ActiveRecord::Base
  enum pay_type: [:mx, :cash, :card, :transfer, :other]
  class << self
    def pay_type_for_select
      pay_types.map do |key, value|
        [I18n.t("enums.membership_card_log.pay_type.#{key}"), value]
      end
    end
  end
end

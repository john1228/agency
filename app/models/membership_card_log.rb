class MembershipCardLog < ActiveRecord::Base
  belongs_to :membership_card
  belongs_to :service
  enum pay_type: [:mx, :cash, :card, :transfer, :other]
  enum action: [:buy, :transfer_card, :disable, :re_activated, :charge, :checkin, :cancel_checkin]
  enum status: [:pending, :confirm, :cancel]
  after_update :backend
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
      MembershipCard.find_by(service_id: service_id, physical_card: entity_number).member
    end
  end


  include AASM
  aasm :status do
    state :pending, :initial => true
    state :confirm
    state :cancel

    event :confirm do
      transitions :from => :pending, :to => :confirm
    end

    event :cancel do
      transitions :from => :pending, :to => :cancel
    end
  end

  protected
  def backend
    if confirm? && status_was.eql?('pending')
      if membership_card.stored? || membership_card.measured?
        membership_card.update(value: membership_card.value - change_amount)
      elsif membership_card.course?
        membership_card.update(supply_value: membership_card.supply_value - change_amount)
      end
    end
  end
end

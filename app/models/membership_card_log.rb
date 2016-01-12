class MembershipCardLog < ActiveRecord::Base
  belongs_to :membership_card
  belongs_to :service
  enum pay_type: [:mx, :cash, :card, :transfer, :other]
  enum action: [:buy, :transfer_card, :disable, :re_activated, :charge, :checkin, :cancel_checkin]
  enum status: [:pending, :confirm, :ignore, :cancel]
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

  def charge(membership_card_id, value)
    self.membership_card_id = membership_card_id
    self.change_amount = value
  end

  include AASM
  aasm :status do
    state :pending, :initial => true
    state :confirm
    state :ignore
    state :cancel

    event :confirm do


      after do
        if membership_card.stored? || membership_card.measured?
          if membership_card.to_be_activated?
            membership_card.update(value: membership_card.value - change_amount, status: 'normal', open: Date.today)
          else
            membership_card.update(value: membership_card.value - change_amount)
          end
        elsif membership_card.course?
          if membership_card.to_be_activated?
            membership_card.update(supply_value: membership_card.supply_value - change_amount, status: 'normal', open: Date.today)
          else
            membership_card.update(supply_value: membership_card.supply_value - change_amount,)
          end
        elsif membership_card.clocked?
          if membership_card.to_be_activated?
            membership_card.update(status: 'normal', open: Date.today)
          end
        end
      end
      transitions from: :pending, to: :confirm, guards: :value_enough?
    end

    event :ignore do
      transitions from: :pending, to: :ignore
    end

    event :cancel do
      after do
        if membership_card.stored? || membership_card.measured?
          membership_card.update(value: membership_card.value + change_amount)
        elsif membership_card.course?
          membership_card.update(supply_value: membership_card.supply_value + change_amount)
        end
      end
      transitions :from => :confirm, :to => :cancel
    end
  end
  protected
  def value_enough?
    if membership_card.course?
      change_amount <= membership_card.supply_value
    elsif membership_card.stored? || membership_card.measured?
      change_amount <= membership_card.value
    elsif membership_card.clocked?
      true
    end
  end
end

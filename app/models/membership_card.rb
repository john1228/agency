class MembershipCard < ActiveRecord::Base
  enum card_type: [:stored, :measured, :clocked, :course]
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

  def checkin
    #未激活会员卡的处理
    if to_be_activated?
      #开卡日期
      created_date = Date.new(created_at.year, created_at.month, created_at.day)
      #最晚开卡日
      last_delay_date = created_date.next_day(delay_days)
      #最晚的有效期
      last_valid_date = last_delay_date.next_date(valid_days) rescue nil
      if last_delay_date >= Date.today
        update(open: Date.today, status: 'normal')
      else
        if last_valid_date.present?
          if last_valid_date >= Date.today
            update(open: last_delay_date, status: 'normal')
          else
            errors.add(expired: '该卡已过期')
          end
        end
      end
    end
    logs.checkin.new.save if normal?
    errors.add(expired: '该卡已过期') if disable?
  end

  def valid_end
    if valid_days.present?
      if to_be_activated?
        #开卡日期
        created_date = Date.new(created_at.year, created_at.month, created_at.day)
        #最晚开卡日
        last_delay_date = created_date.next_day(delay_days)
        #最晚的有效期
        last_valid_date = last_delay_date.next_date(valid_days)

        if last_valid_date >= Date.today
          last_valid_date
        else
          '已过期'
        end
      else
        open.next_day(valid_days)
      end
    else
      '永久'
    end
  end
end

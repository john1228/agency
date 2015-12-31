module Api
  class TerminalController < ApplicationController
    def active

    end

    def show
      service = Service.first
      render json: {
                 ver: Time.now.to_i,
                 time: Time.now.strftime('%Y-%m-%d')
             }
    end

    def checkin
      card = MembershipCard.find(id)
      if card.present?
        if card.valid_start <= Date.today && card.valid_end >= Date.today
          render json: {
                     code: 1,
                     data: {
                         card: card.id,
                         name: card.name,
                         value: card.value,
                         start: card.valid_start,
                         end: card.valid_end
                     }
                 }
        else
          render json: {code: 0, message: '该卡已过期或者余额不足'}
        end
      else
        render json: {code: 1, message: '无效的会员卡'}
      end
    end
  end
end


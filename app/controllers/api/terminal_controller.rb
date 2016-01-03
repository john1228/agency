module Api
  class TerminalController < ApplicationController
    def active
      terminal = Terminal.new(active_params)
      if terminal.save
        render json: {code: 1, data: {token: terminal.token}}
      else
        render json: {code: 0, message: terminal.errors.messages.values.join(';')}
      end
    end

    def show
      service = Service.first
      render json: {
                 ver: Time.now.strftime('%Y%m%d%H%M%S'),
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

    protected
    def active_params
      params.permit(:terminal, :mxid)
    end
  end
end


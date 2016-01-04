module Api
  class TerminalController < ApplicationController
    before_action :auth, only: [:show, :checkin]

    def active
      terminal = Terminal.new(active_params)
      if terminal.save
        Rails.cache.write(terminal.token, terminal)
        render json: {code: 1, data: {token: terminal.token}}
      else
        render json: {code: 0, message: terminal.errors.messages.values.join(';')}
      end
    end

    def show
      service = @terminal.service
      time = Time.parse(params[:ver]) rescue Time.parse('2015-01-01')
      render json: {
                 ver: MembershipCard.where(service: service).where('updated_at > ?', time).order(updated_at: :desc).first.updated_at.strftime('%Y%m%d%H%M%S'),
                 time: Time.now.strftime('%Y-%m-%d'),
                 name: service.profile.name,
                 avatar: service.profile.avatar,
                 card: MembershipCard.where(service: service).where('updated_at > ?', time).map { |membership_card|
                   membership_card.as_json(
                       only: [:id, :name, :card_type, :value],
                       methods: [:valid_start, :valid_end],
                       include: {member: {only: [:name, :avatar]}}
                   )
                 }
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

    def auth
      @terminal = Rails.cache.fetch(request.headers[:token])
      render json: {code: 0, message: '终端未激活'} if @terminal.blank?
    end
  end
end


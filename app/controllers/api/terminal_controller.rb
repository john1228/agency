module Api
  class TerminalController < ActionController::Base
    before_filter :auth, only: [:show, :checkin]

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
                 code: 1,
                 data: {
                     ver: MembershipCard.where(service: service).where('updated_at > ?', time).order(updated_at: :desc).first.updated_at.strftime('%Y%m%d%H%M%S'),
                     time: Time.now.strftime('%Y-%m-%d'),
                     name: service.profile.name,
                     avatar: service.profile.avatar,
                     card: MembershipCard.where(service: service).where('updated_at > ?', time).map { |membership_card|
                       {
                           id: membership_card.id,
                           name: membership_card.name,
                           card_type: membership_card.card_type,
                           value: membership_card.value,
                           valid_end: membership_card.valid_end,
                           member: {
                               name: membership_card.member.name,
                               avatar: membership_card.member.avatar
                           }
                       }
                     }
                 }
             }
    end

    def checkin
      membership_card = MembershipCard.find(id)
      if card.present?
        if card.valid_start <= Date.today && card.valid_end >= Date.today
          membership_card.checkin
          render json: {
                     code: 1,
                     data: {
                         card: {
                             id: membership_card.id,
                             name: membership_card.name,
                             card_type: membership_card.card_type,
                             value: membership_card.value,
                             valid_end: membership_card.valid_end,
                             member: {
                                 name: membership_card.member.name,
                                 avatar: membership_card.member.avatar
                             }
                         }
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


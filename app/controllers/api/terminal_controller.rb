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
      membership_cards = MembershipCard.where(service: service).where('updated_at > ?', time).find_all { |membership_card|
        !membership_card.valid_end.eql?('已过期') && (membership_card.to_be_activated? || membership_card.normal?)
      }

      render json: {
                 code: 1,
                 data: {
                     ver: (MembershipCard.where(service: service).where('updated_at > ?', time).order(updated_at: :desc).first.updated_at.strftime('%Y%m%d%H%M%S') rescue Time.now.strftime('%Y%m%d%H%M%S')),
                     mxing: ['http://7xnvtv.com2.z0.glb.qiniucdn.com/a1.png',
                             'http://7xnvtv.com2.z0.glb.qiniucdn.com/a2.png'],
                     venue: {
                         first: ['http://7xnvtv.com2.z0.glb.qiniucdn.com/b1-1.png',
                                 'http://7xnvtv.com2.z0.glb.qiniucdn.com/b1-2.png'],
                         second: ['http://7xnvtv.com2.z0.glb.qiniucdn.com/b2-1.png',
                                  'http://7xnvtv.com2.z0.glb.qiniucdn.com/b2-2.png'],
                         third: ['http://7xnvtv.com2.z0.glb.qiniucdn.com/b3-1.png',
                                 'http://7xnvtv.com2.z0.glb.qiniucdn.com/b3-2.png']
                     },
                     time: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
                     name: service.profile.name,
                     avatar: service.profile.avatar.url,
                     card: membership_cards.map { |membership_card|
                       physical_card = PhysicalCard.find_by(virtual_number: membership_card.physical_card)
                       {
                           id: membership_card.id,
                           name: membership_card.name,
                           card_type: membership_card.card_type,
                           value: membership_card.value,
                           valid_end: membership_card.valid_end,
                           member_name: membership_card.member.name,
                           member_avatar: (membership_card.member.avatar.url rescue ''),
                           physical_card: (physical_card.entity_number rescue '')
                       }
                     }
                 }
             }
    end

    def checkin
      service = Service.find_by_mxid(@terminal.mxid)
      physical_card = PhysicalCard.find_by(entity_number: params[:id])
      if physical_card.blank?
        render json: {code: 0, message: '无效的会员卡'}
      else
        membership_cards = MembershipCard.where(physical_card: physical_card.virtual_number, service_id: service.id)
        if membership_cards.blank?
          render json: {code: 0, message: '无效的会员卡'}
        else
          valid_cards = membership_cards.find_all { |membership_card|
            (membership_card.value||0) > 0 && !membership_card.valid_end.eql?('已过期')
          }
          if valid_cards.present?
            MembershipCardLog.checkin.create(
                service_id: service.id,
                entity_number: physical_card.virtual_number,
                remark: '终端机签到'
            )
            render json: {
                       code: 1,
                       data: {
                           card: valid_cards.map { |membership_card|
                             physical_card = PhysicalCard.find_by(virtual_number: membership_card.physical_card)
                             {
                                 id: membership_card.id,
                                 name: membership_card.name,
                                 card_type: membership_card.card_type,
                                 value: membership_card.value,
                                 valid_end: membership_card.valid_end,
                                 member_name: membership_card.member.name,
                                 member_avatar: (membership_card.member.avatar.url rescue ''),
                                 physical_card: physical_card.entity_number
                             }
                           }
                       }
                   }
          else
            render json: {code: 0, message: '会员卡已过期或者余额不足'}
          end
        end
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


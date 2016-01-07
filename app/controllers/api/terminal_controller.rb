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
                     mxing: ['http://h.hiphotos.baidu.com/image/pic/item/00e93901213fb80e7c4a24ce31d12f2eb938940b.jpg',
                             'http://e.hiphotos.baidu.com/image/pic/item/f2deb48f8c5494eeecd34b002af5e0fe99257e31.jpg'],
                     venue: {
                         first: ['http://f.hiphotos.baidu.com/image/pic/item/7dd98d1001e939012499c8277cec54e736d1960b.jpg',
                                 'http://c.hiphotos.baidu.com/image/pic/item/7aec54e736d12f2eb3f4ea7948c2d56285356831.jpg'],
                         second: ['http://e.hiphotos.baidu.com/image/pic/item/37d12f2eb9389b50430ea44b8235e5dde7116e31.jpg',
                                  'http://a.hiphotos.baidu.com/image/pic/item/77094b36acaf2edda36a0cf08a1001e93901930b.jpg'],
                         third: ['http://h.hiphotos.baidu.com/image/pic/item/3801213fb80e7bec532b47f8282eb9389b506b31.jpg',
                                 'http://f.hiphotos.baidu.com/image/pic/item/8c1001e93901213fbdc20ac553e736d12f2e9531.jpg']
                     },
                     time: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
                     name: service.profile.name,
                     avatar: service.profile.avatar.url,
                     card: MembershipCard.where(service: service).where('updated_at > ?', time).map { |membership_card|
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
            membership_card.value > 0 && !membership_card.valid_end.eql?('已过期')
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


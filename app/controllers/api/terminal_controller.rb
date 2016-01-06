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
                     mxing: ['http://h.hiphotos.baidu.com/image/pic/item/4ec2d5628535e5dd2820232370c6a7efce1b623a.jpg', 'http://a.hiphotos.baidu.com/image/pic/item/9c16fdfaaf51f3de6cee3f9892eef01f3b2979ea.jpg'],
                     venue: {
                         first: ['http://f.hiphotos.baidu.com/image/pic/item/838ba61ea8d3fd1f7ca6f808374e251f95ca5f50.jpg',
                                 'http://d.hiphotos.baidu.com/image/pic/item/b21bb051f819861865a669784ced2e738ad4e66d.jpg'],
                         second: ['http://h.hiphotos.baidu.com/image/pic/item/6609c93d70cf3bc798e14b10d700baa1cc112a6c.jpg',
                                  'http://b.hiphotos.baidu.com/image/pic/item/8435e5dde71190efa71d1423c81b9d16fcfa606c.jpg'],
                         third: ['http://b.hiphotos.baidu.com/image/pic/item/7aec54e736d12f2e70a7289c49c2d562843568a8.jpg',
                                 'http://h.hiphotos.baidu.com/image/pic/item/dbb44aed2e738bd4644fb353a78b87d6277ff962.jpg']
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
                           member: {
                               name: membership_card.member.name,
                               avatar: (membership_card.member.avatar.url rescue '')
                           },
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
                physical_card: params[:id],
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
                                 member: {
                                     name: membership_card.member.name,
                                     avatar: (membership_card.member.avatar.url rescue '')
                                 },
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


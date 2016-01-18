module Api
  class TerminalController < ActionController::Base
    before_filter :auth, only: [:show, :checkin]

    def active
      terminal = Terminal.new(active_params.merge(last_sign_in_ip: request.remote_ip))
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
      @terminal.update(last_sign_in_ip: request.remote_ip)
      banner = SBanner.find_by(service: service)
      render json: {
                 code: 1,
                 data: {
                     ver: (MembershipCard.where(service: service).where('updated_at > ?', time).order(updated_at: :desc).first.updated_at.strftime('%Y%m%d%H%M%S') rescue Time.now.strftime('%Y%m%d%H%M%S')),
                     mxing: ['http://7xnvtv.com2.z0.glb.qiniucdn.com/a1.png',
                             'http://7xnvtv.com2.z0.glb.qiniucdn.com/a2.png'],
                     venue: {
                         first: banner.blank? ? ['http://7xnvtv.com2.z0.glb.qiniucdn.com/b1-1.png',
                                                 'http://7xnvtv.com2.z0.glb.qiniucdn.com/b1-2.png'] : banner.pos_1.map { |image| image.url },
                         second: banner.blank? ? ['http://7xnvtv.com2.z0.glb.qiniucdn.com/b2-1.png',
                                                  'http://7xnvtv.com2.z0.glb.qiniucdn.com/b2-2.png'] : banner.pos_2.map { |image| image.url },
                         third: banner.blank? ? ['http://7xnvtv.com2.z0.glb.qiniucdn.com/b3-1.png',
                                                 'http://7xnvtv.com2.z0.glb.qiniucdn.com/b3-2.png'] : banner.pos_3.map { |image| image.url }
                     },
                     time: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
                     name: service.profile.name,
                     avatar: service.profile.avatar.url,
                     card: MembershipCard.where(service: service).where('updated_at > ?', time).map { |membership_card|
                       physical_card = PhysicalCard.find_by(virtual_number: membership_card.physical_card)
                       if membership_card.clocked?
                         if membership_card.valid_end.eql?('已过期')
                           remain_value = 0
                         else
                           remain_value = (membership_card.valid_end - Date.today).floor
                         end
                       elsif membership_card.course?
                         remain_value = membership_card.supply_value
                       else
                         remain_value = membership_card.value
                       end
                       {
                           id: membership_card.id,
                           name: membership_card.name,
                           card_type: membership_card.card_type,
                           value: remain_value,
                           valid_end: membership_card.valid_end,
                           member_name: membership_card.member.name,
                           member_avatar: (membership_card.member.avatar.url rescue ''),
                           physical_card: (physical_card.entity_number rescue ''),
                           status: membership_card.status
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
            if membership_card.course?
              membership_card.supply_value > 0 && !membership_card.valid_end.eql?('已过期')
            elsif membership_card.clocked?
              !membership_card.valid_end.eql?('已过期')
            else
              membership_card.value > 0 && !membership_card.valid_end.eql?('已过期')
            end
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
                           card: membership_cards.map { |membership_card|
                             physical_card = PhysicalCard.find_by(virtual_number: membership_card.physical_card)
                             if membership_card.clocked?
                               if membership_card.valid_end.eql?('已过期')
                                 remain_value = 0
                               else
                                 remain_value = (membership_card.valid_end - Date.today).floor
                               end
                             elsif membership_card.course?
                               remain_value = membership_card.supply_value
                             else
                               remain_value = membership_card.value
                             end
                             {
                                 id: membership_card.id,
                                 name: membership_card.name,
                                 card_type: membership_card.card_type,
                                 value: remain_value,
                                 valid_end: membership_card.valid_end,
                                 member_name: membership_card.member.name,
                                 member_avatar: (membership_card.member.avatar.url rescue ''),
                                 physical_card: (physical_card.entity_number rescue ''),
                                 status: membership_card.status
                             }
                           }
                       }
                   }
          else
            render json: {code: 1, data: {
                       card: membership_cards.map { |membership_card|
                         physical_card = PhysicalCard.find_by(virtual_number: membership_card.physical_card)
                         if membership_card.clocked?
                           remain_value = 0
                         elsif membership_card.course?
                           remain_value = membership_card.supply_value
                         else
                           remain_value = membership_card.value
                         end
                         {
                             id: membership_card.id,
                             name: membership_card.name,
                             card_type: membership_card.card_type,
                             value: remain_value,
                             valid_end: membership_card.valid_end,
                             member_name: membership_card.member.name,
                             member_avatar: (membership_card.member.avatar.url rescue ''),
                             physical_card: (physical_card.entity_number rescue ''),
                             status: membership_card.status
                         }
                       }
                   }}
          end
        end
      end
    end

    protected
    def active_params
      params.permit(:terminal, :mxid).merge(terminal: params[:tid])
    end

    def auth
      @terminal = Rails.cache.fetch(request.headers[:token])
      render json: {code: 0, message: '终端未激活'} if @terminal.blank?
    end
  end
end


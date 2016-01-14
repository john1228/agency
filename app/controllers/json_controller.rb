class JsonController < ApplicationController
  def card_types
    @membership_card_types = MembershipCardType.where(card_type: params[:type], service_id: params[:service_id])
    render json: @membership_card_types.map { |card_type|
             card_type.as_json(only: [:id, :name, :value, :price, :valid_days, :delay_days])
           }
  end

  def coaches
    service = Service.find(params[:service_id])
    render json: service.coaches.map { |coach|
             {
                 id: coach.id,
                 name: coach.profile.name
             }
           }
  end

  def salesman
    salesman = AdminUser.sale.where(service_id: params[:service_id])
    render json: salesman.map { |item|
             {
                 id: item.id,
                 name: item.name
             }
           }
  end

  def balance
    service = Service.find(params[:service_id])
    render json: {balance: service.wallet.balance.to_f.round(2)}
  end

  def member
    service = Service.find(params[:service_id])
    render json: Member.where(service: service).map { |member|
             {
                 id: member.id,
                 name: member.name,
                 mobile: member.mobile
             }
           }
  end
end


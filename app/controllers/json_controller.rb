class JsonController < ApplicationController
  def card_types
    @membership_card_types = MembershipCardType.where(card_type: params[:type], service_id: params[:service_id])
    render json: @membership_card_types.map { |card_type|
             card_type.as_json(only: [:id, :name, :count, :price, :valid_days, :latest_delay_days])
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
    salesman = AdminUser.sales.where(service_id: params[:service_id])
    render json: salesman.map { |item|
             {
                 id: item.id,
                 name: item.name
             }
           }
  end
end

class TransfersController < ApplicationController
  layout 'admin'

  def index
    filter = {}
    if params[:service].present?
      service = Service.find(params[:service])
      filter[:wallet_id] = service.wallet.id
    end
    @logs = WalletLog.transfer.joins(:wallet)
                .where(wallets: {user_id: current_user.all_services.pluck(:id)})
                .where(filter)
                .order(id: :desc)
                .paginate(page: params[:page]||1, per_page: 5)
    @type = params[:type]||'signal'
  end

  def create
    service = Service.find(params[:service])
    coach = service.coaches.find(params[:coach])
    coach_wallet = Wallet.find_or_create_by(user: coach)
    service_wallet = Wallet.find_or_create_by(user: service)
    Wallet.transaction do
      coach_wallet.update_attributes(
          action: WalletLog.actions['transfer'],
          balance: coach_wallet.balance + BigDecimal(params[:amount]),
          source: service.id,
          operator: current_user.name
      )
      service_wallet.update_attributes(
          action: WalletLog.actions['transfer'],
          balance: service_wallet.balance - BigDecimal(params[:amount]),
          source: coach.id,
          operator: current_user.name
      )
    end
    redirect_to action: :index
  end

  def service
    service = Service.find(params[:service_id])
    render json: {
               balance: service.wallet.balance.to_i,
               coach: service.coaches.map { |coach|
                 {
                     id: coach.id,
                     name: coach.profile.name
                 }
               }
           }
  end
end

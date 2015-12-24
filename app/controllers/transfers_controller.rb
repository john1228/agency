class TransfersController < ApplicationController
  layout 'admin'

  def index
    @logs = WalletLog.transfer.joins(:wallet)
                .where(wallets: {user_id: current_user.all_services.pluck(:id)})
                .order(id: :desc)
                .paginate(page: params[:page]||1, per_page: 10)
    @transfer = ''
  end

  def create
    service = Service.find(params[:service])
    coach = service.coaches.find(params[:coach])
    coach_wallet = Wallet.find_or_create_by(user: coach)
    service_wallet = Wallet.find_or_create_by(user: service)
    Wallet.transaction do
      coach_wallet.update_attributes(
          action: WalletLog::ACTIONS['转账'],
          balance: coach_wallet.balance + BigDecimal(params[:amount])
      )
      service_wallet.update_attributes(
          action: WalletLog::ACTIONS['转账'],
          balance: coach_wallet.balance - BigDecimal(params[:amount])
      )
    end
    redirect_to action: :index
  end

  def log
    log = WalletLog.transfer.joins(:wallet)
              .where(wallets: {user_id: current_user.all_services.pluck(:id)})
              .order(id: :desc)
              .paginate(page: params[:page]||1, per_page: 10)
  end
end

class FinanceController < ApplicationController
  layout 'login'

  def transfer_new
    render 'transfer'
  end

  def transfer_create
    coach_wallet = Wallet.find_or_create_by(user_id: params[:coach])
    service_wallet = @service.wallet
    begin
      coach_wallet.with_lock do
        coach_wallet.balance = coach_wallet.balance + BigDecimal(params[:amount])
        coach_wallet.action = WalletLog::ACTIONS['转账']
        coach_wallet.save
      end
      service_wallet.with_lock do
        service_wallet.balance = service_wallet.balance - BigDecimal(params[:amount])
        service_wallet.action = WalletLog::ACTIONS['转账']
        service_wallet.save
      end
      @success = true
    rescue Exception => exp
      @error = exp.message
    end
    render 'transfer'
  end

  def withdraw_new
    render 'withdraw'
  end

  def withdraw_create
    render 'withdraw'
  end
end

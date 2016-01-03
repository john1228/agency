class WithdrawsController < ApplicationController
  layout 'admin'

  def index
    filter = {}
    if params[:service].present?
      service = Service.find(params[:service])
      filter[:wallet_id] = service.wallet.id
    end
    @success = params[:success]
    @failure = params[:failure]
    @logs = WalletLog.withdraw.joins(:wallet)
                .where(wallets: {user_id: current_user.all_services.pluck(:id)})
                .where(filter)
                .order(id: :desc)
                .paginate(page: params[:page]||1, per_page: 10)
    @withdraw = Withdraw.new
  end

  def create
    @withdraw = Withdraw.new(withdraw_params.merge(operator: current_user.name))
    if @withdraw.save
      redirect_to action: :index, success: '提现成功'
    else
      @withdraw.errors.each { |k, v|
        logger.info "#{k}::#{v}"
      }
      redirect_to action: :index, failure: '提现失败'
    end
  end

  protected
  def withdraw_params
    params.require(:withdraw).permit(:coach_id, :account, :name, :amount)
  end
end

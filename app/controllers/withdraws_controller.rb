class WithdrawsController < ApplicationController
  layout 'admin'

  def index
    @logs = WalletLog.withdraw.joins(:wallet)
                .where(wallets: {user_id: params[:service]||current_user.all_services.pluck(:id)})
                .order(id: :desc)
                .paginate(page: params[:page]||1, per_page: 10)
    @withdraw = Withdraw.new
  end

  def create
    @withdraw = Withdraw.new(withdraw_params.merge(operator: current_user.name))
    if @withdraw.save
      flash[:success] = "提现成功"
      redirect_to action: :index
    else
      flash[:danger] = "提现失败:" +@withdraw.errors.messages.values.join(';')
      redirect_to action: :index
    end
  end

  protected
  def withdraw_params
    params.require(:withdraw).permit(:coach_id, :account, :name, :amount)
  end
end

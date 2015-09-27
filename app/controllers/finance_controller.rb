class FinanceController < ApplicationController
  layout 'admin'

  def transfer_new
    @coaches = @service.coaches.order(id: :desc).collect { |coach| coach.profile.name }
    @data = @service.coaches.order(id: :desc).map { |coach| rand(10000) }
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


  def batch_transfer
    service_wallet = @service.wallet
    params[:account].each_index { |index|
      coach_wallet = Wallet.find_or_create_by(user_id: params[:account][index])
      begin
        coach_wallet.with_lock do
          coach_wallet.balance = coach_wallet.balance + BigDecimal(params[:amount][index])
          coach_wallet.action = WalletLog::ACTIONS['转账']
          coach_wallet.save
        end
        service_wallet.with_lock do
          service_wallet.balance = service_wallet.balance - BigDecimal(params[:amount][index])
          service_wallet.action = WalletLog::ACTIONS['转账']
          service_wallet.save
        end
      rescue Exception => exp
        error_index = index
      end
    }
    @success = true
    render 'transfer'
  end

  def withdraw_new
    @alipay = Rails.cache.fetch(@service.id)
    render 'withdraw'
  end

  def withdraw_create
    @alipay = Rails.cache.fetch(@service.id)
    if @alipay.blank?
      Rails.cache.write(@service.id, {account: params[:account], name: params[:name]})
      withdraw_params = {coach_id: @service.id, account: params[:account], name: params[:name], account: params[:account]}
    else
      withdraw_params = {coach_id: @service.id, account: @alipay[:account], name: @alipay[:name], account: params[:account]}
    end
    withdraw = Withdraw.new(withdraw_params)
    if withdraw.save
      @success = true
    else
      @error = true
    end
    render 'withdraw'
  end
end

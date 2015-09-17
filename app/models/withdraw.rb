class Withdraw < ActiveRecord::Base
  belongs_to :coach
  before_create :reduce
  STATUS ={'未处理' => 0, '已处理' => 1}

  private
  def reduce
    begin
      wallet = Wallet.find_or_create_by(user_id: coach_id)
      wallet.with_lock do
        wallet.balance = wallet.balance - amount
        wallet.action = WalletLog::ACTIONS['提现']
        wallet.save
      end
    rescue
      false
    end
  end
end

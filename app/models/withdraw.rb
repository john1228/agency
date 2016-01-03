class Withdraw < ActiveRecord::Base
  belongs_to :user
  before_create :reduce
  validates_numericality_of :amount, greater_than_or_equal_to: 200, message: '提现金额不能少于200元'
  validates_presence_of :account, message: '请填写支付宝账户'
  validates_presence_of :name, message: '请填写支付宝账户对应的实名'

  attr_accessor :operator

  enum status: [:request, :processed, :success, :failed]
  private
  def reduce
    wallet = Wallet.find_or_create_by(user_id: coach_id)
    if wallet.update_attributes(
        balance: wallet.balance - amount,
        action: 'withdraw',
        source: account,
        operator: operator
    )
      true
    else
      false
    end
  end
end

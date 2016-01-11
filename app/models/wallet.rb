class Wallet < ActiveRecord::Base
  belongs_to :user
  has_many :wallet_logs
  attr_accessor :action, :source, :operator

  after_update :create_wallet_log

  private
  def create_wallet_log
    wallet_logs.create(
        action: action,
        balance: balance - balance_was,
        integral: integral - integral_was,
        coupons: coupons.size > coupons_was.size ? (coupons - coupons_was) : (coupons_was - coupons),
        bean: bean - bean_was,
        source: source,
        operator: operator
    )
  end
end

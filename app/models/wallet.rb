class Wallet < ActiveRecord::Base
  belongs_to :user
  has_many :wallet_logs
  attr_accessor :action
  after_update :create_wallet_log

  def as_json
    {
        balance: balance.to_f.round(2),
        coupons: coupons.size,
        bean: bean
    }
  end

  def valid_coupons(sku, amount)
    #TODO: 筛选可用的优惠券,暂时不做商品区分
    sku = Sku.find_by(sku: sku)
    total = sku.selling_price * amount
    valid_coupons = Coupon.where(id: coupons, limit_category: Coupon::TYPE[:general]).where('min <= ? and start_date <= ? and end_date >= ?', total, Date.today, Date.today)
    valid_coupons
  end

  private
  def create_wallet_log
    coupons_change
    if coupons.size > coupons_was.size
      coupons_change = coupons - coupons_was #增加优惠券
    else
      coupons_change = coupons_was - coupons #减少优惠券
    end
    wallet_logs.create(
        action: action,
        balance: (balance-balance_was),
        coupons: coupons_change,
        bean: bean - bean_was
    )
  end
end

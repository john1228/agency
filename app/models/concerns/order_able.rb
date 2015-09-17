module OrderAble
  extend ActiveSupport::Concern

  def check_coupon(coupon)
    #只能使用一张优惠券
    # use_coupons = coupons.split(',').map { |coupon| coupon.to_i }
    #判断使用的优惠券是否是用户拥有的优惠券
    return false unless user.wallet.coupons.include?(coupon.id)
    #优惠券不在有效期内
    return false if (coupon.start_date> Date.today) || (coupon.end_date< Date.today)
    #种类是否满足要求,暂时移除
    case coupon.limit_category
      when Coupon::TYPE[:general]
        return true
      when Coupon::TYPE[:gyms]
        return false
      when Coupon::TYPE[:course]
        return false
      when Coupon::TYPE[:service]
        return false
      else
        return false
    end
  end
end
class Coupon < ActiveRecord::Base
  #优惠范围(通用,限制私教,限制产品,限制服务号)
  STATUS = {offline: 0, online: 1}
  TYPE = {general: 1, gyms: 2, course: 3, service: 4}
  validates_presence_of :name, :limit_category, :start_date, :end_date, :discount, :min, :amount
  validates_presence_of :limit_ext, if: Proc.new { |coupon|
                                    coupon.limit_category.eql?(TYPE[:gyms])||coupon.limit_category.eql?(TYPE[:course])||coupon.limit_category.eql?(TYPE[:service])
                                  }

  def as_json
    {
        no: id,
        name: name,
        discount: discount.to_i.to_s,
        info: info,
        start_date: start_date,
        end_date: end_date,
        limit_category: limit_category,
        limit_ext: limit_ext,
        min: min.to_i,
        amount: amount
    }
  end
end

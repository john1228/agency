class Order < ActiveRecord::Base
  default_scope { where(status: 2).order(updated_at: :desc) }
  has_one :order_item, dependent: :destroy
  belongs_to :user

  def pay_type_name
    case pay_type
      when '1'
        '支付宝'
      when '2'
        '微信'
      when '3'
        '京东'
    end
  end
end

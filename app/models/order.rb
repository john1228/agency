class Order < ActiveRecord::Base
  default_scope { where(status: 2) }
  scope :top_30, ->(date) { select("SUM(total) as sale,coach_id").where(updated_at: date.at_beginning_of_day..date.next_month.at_beginning_of_day).group(:coach_id).order('sale desc').limit(30) }
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

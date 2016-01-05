class Order < ActiveRecord::Base
  default_scope { where(status: 2) }
  scope :top_30, ->(date) { select("SUM(total) as sale,coach_id").where(updated_at: date.at_beginning_of_day..date.next_month.at_beginning_of_day).group(:coach_id).order('sale desc').limit(30) }
  has_one :order_item, dependent: :destroy
  belongs_to :user
  belongs_to :service
  enum pay_type: [:alipay, :wx, :jd]
  enum order_type: [:platform, :face_to_face]
end

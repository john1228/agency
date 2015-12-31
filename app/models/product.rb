class Product < ActiveRecord::Base
  has_one :sku, dependent: :destroy, foreign_key: :course_id
  has_one :prop, class: ProductProp
  attr_accessor :service_id, :market_price, :selling_price, :store, :limit, :seller_id
  belongs_to :card_type, class: MembershipCardType

  validates_presence_of :card_type_id, message: '请选择卡'
  validates_presence_of :name, message: '请输入出售卡的卡名'
  validates_presence_of :description, message: '请输入对卡的说明'

  mount_uploaders :image, ImagesUploader
  after_create :generate_sku


  accepts_nested_attributes_for :prop

  private
  def generate_sku
    GenerateSkuJob.perform_now(product, {
                                          service_id: service_id,
                                          market_price: market_price,
                                          selling_price: selling_price,
                                          store: store||'-1',
                                          limit: limit||'-1',
                                          seller_id: seller_id
                                      })
  end
end

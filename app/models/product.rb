class Product < ActiveRecord::Base
  has_one :sku, dependent: :destroy, foreign_key: :course_id
  has_one :prop, class: ProductProp
  attr_accessor :service_id, :market_price, :selling_price, :store, :limit, :seller_id
  belongs_to :card_type, class: MembershipCardType
  has_one :service, through: :sku

  validates_presence_of :card_type_id, message: '请选择卡'
  validates_presence_of :name, message: '请输入出售卡的卡名'
  validates_presence_of :description, message: '请输入对卡的说明'

  mount_uploaders :image, ProductImagesUploader
  accepts_nested_attributes_for :prop
  after_create :build_default_sku
  protected
  def build_default_sku
    service = Service.find(service_id)
    create_sku(
        sku: 'SM'+'-' + '%06d' % id + '-' + '%06d' % (service.id),
        course_type: card_type_id,
        course_name: name,
        course_cover: (image.first.url rescue ''),
        seller: service.profile.name,
        seller_id: seller_id||service_id,
        service_id: service_id,
        market_price: market_price,
        selling_price: selling_price,
        store: store,
        limit: limit,
        address: service.profile_address,
        coordinate: (service.place.lonlat rescue 'POINT(0 0)'),
        status: 'online',
        sku_type: 'card'
    )
  end
end

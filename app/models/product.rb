class Product < ActiveRecord::Base
  has_one :sku, dependent: :destroy, foreign_key: :course_id
  has_one :prop, class: ProductProp
  attr_accessor :service_id, :market_price, :selling_price, :store, :limit, :seller_id
  belongs_to :card_type, class: MembershipCardType

  mount_uploaders :image, ImagesUploader
  after_create :generate_sku

  accepts_nested_attributes_for :prop
  
  private
  def generate_sku
    service = Service.find(service_id)
    Sku.card.create(
        sku: 'SM'+'-' + '%06d' % id + '-' + '%06d' % (service.id),
        course_id: id,
        course_type: type,
        course_name: name,
        seller: service.profile.name,
        seller_id: seller_id||service.id,
        service_id: service_id,
        market_price: market_price,
        selling_price: selling_price,
        store: store,
        limit: limit,
        address: service.profile_address,
        coordinate: (service.place.lonlat rescue 'POINT(0 0)'),
        status: Sku.statuses[:online]
    )
  end
end

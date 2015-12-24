class Product < ActiveRecord::Base
  self.inheritance_column = false
  has_one :sku, dependent: :destroy, foreign_key: :course_id
  attr_accessor :service_id, :market_price, :selling_price, :store, :limit

  mount_uploaders :image, ImagesUploader
  after_create :generate_sku

  def card_type
    MembershipCardType.find(type)
  end

  private
  def generate_sku
    service = Service.find(service_id)
    Sku.card.create(
        sku: 'SM'+'-' + '%06d' % id + '-' + '%06d' % (service.id),
        course_id: id,
        course_type: type,
        course_name: name,
        seller: service.profile.name,
        seller_id: service_id,
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

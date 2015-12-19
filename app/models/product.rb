class Product < ActiveRecord::Base
  has_one :sku, dependent: :destroy, foreign_key: :course_id
  attr_accessor :service_id, :market_price, :selling_price, :store, :limit
  
  after_create :generate_sku
  private
  def generate_sku
    service = Service.find(service_id)
    Sku.card.create(
        sku: 'SM'+'-' + '%06d' % id + '-' + '%06d' % (service.id),
        course_id: id,
        course_type: type,
        course_name: name,

        seller: service.profile.name,
        seller_id: service.id,
        market_price: market_price,
        selling_price: selling_price,
        store: store,
        limit: limit,
        address: service.profile_address,
        coordinate: (service.place.lonlat rescue 'POINT(0 0)')
    )

  end
end

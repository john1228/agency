class GenerateSkuJob < ActiveJob::Base
  queue_as :default

  def perform(product, params= {})
    service = Service.find(params[:service_id])
    Sku.card.create(
        sku: 'SM'+'-' + '%06d' % product.id + '-' + '%06d' % (service.id),
        course_id: product.id,
        course_type: product.card_type_id,
        course_name: product.name,
        course_cover: product.image.first.url,
        seller: service.profile.name,
        seller_id: params[:seller_id]||params[:service_id],
        service_id: params[:service_id],
        market_price: params[:market_price],
        selling_price: params[:selling_price],
        store: params[:store],
        limit: params[:limit],
        address: service.profile_address,
        coordinate: (service.place.lonlat rescue 'POINT(0 0)'),
        status: 1
    )
  end
end

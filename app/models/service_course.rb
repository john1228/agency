class ServiceCourse < ActiveRecord::Base
  self.inheritance_column = nil
  STATUS = {offline: 0, online: 1}
  attr_accessor :agency, :market_price, :selling_price, :store, :limit, :limit_time
  after_create :generate_sku
  after_update :online_or_offline
  validates_presence_of :name, :type, :style, :during, :proposal, :exp, :intro

  mount_uploaders :image, ImagesUploader

  def cover
    image.first.thumb.url
  end

  def type_name
    (INTERESTS['items'].detect { |item| item['id']==type })['name']
  end

  private
  def generate_sku
    agencies = Service.where(id: agency)
    agencies.each { |agency|
      Sku.create(
          sku: 'SC'+'-' + '%06d' % id + '-' + '%06d' % (agency.id),
          course_id: id,
          course_type: type,
          course_name: name,

          seller: agency.profile.name,
          seller_id: agency.id,
          market_price: market_price,
          selling_price: selling_price,
          store: store,
          limit: limit,
          address: agency.profile.address||'',
          coordinate: (agency.place.lonlat rescue 'POINT(0 0)')
      )
    }
  end

  def online_or_offline
    if status.eql?(STATUS[:online])
      Sku.where("sku LIKE 'SC%' and course_id = #{id}").map { |item| item.update(status: STATUS[:online], course_cover: cover) }
    else
      Sku.where("sku LIKE 'SC%' and course_id = #{id}").update_all(status: STATUS[:offline])
      #移除爆款列表
      Recommend.delete_all(recommended_id: Sku.where("sku LIKE 'SC%' and course_id = #{id}").pluck(:id), type: Recommend::TYPE[:course])
    end
  end
end

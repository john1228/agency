class Place < ActiveRecord::Base
  scope :nearby, ->(lng, lat, filters, page=1) { find_by_sql("select profiles.*,st_distance(places.lonlat, 'POINT(#{lng} #{lat})') as distance from profiles,places where  st_dwithin(places.lonlat, 'POINT(#{lng} #{lat})',15000000) and profiles.user_id=places.user_id and #{filters} order by distance asc, profiles.id desc limit 25 offset (#{page}-1)*25") }
  scope :nearby_services, ->(lng, lat, page=1) { find_by_sql("select profiles.*,st_distance(places.lonlat, 'POINT(#{lng} #{lat})') as distance from profiles,places where profiles.identity=2 and st_dwithin(places.lonlat, 'POINT(#{lng} #{lat})',15000000) and profiles.user_id=places.user_id order by distance asc limit 25 offset (#{page}-1)*25") }
  belongs_to :user
  validates_uniqueness_of :user_id, message: '用户已经有定位信息'
  set_rgeo_factory_for_column(:lonlat, RGeo::Geographic.spherical_factory(:srid => 4326))

  def as_json
    user.summary_json.merge(distance: distance.to_i)
  end
end

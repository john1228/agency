class Service<User
  default_scope { joins(:profile).where('profiles.identity' => 2) }
  after_save :location
  has_many :service_members, dependent: :destroy
  has_many :service_photos, foreign_key: :user_id, dependent: :destroy
  has_many :service_dynamics, foreign_key: :user_id, dependent: :destroy

  has_many :service_members, dependent: :destroy
  has_many :coaches, through: :service_members
  alias_attribute :service_id, :id

  private
  def location
    conn = Faraday.new(:url => 'http://api.map.baidu.com')
    address_summary = ((profile.province.to_s + profile.city.to_s + profile.address.to_s).match(/(.+?)[弄号]/)).to_s
    result = conn.get '/geocoder/v2/', address: address_summary.blank? ? address : address_summary, output: 'json', ak: '61Vl2dO7CKCt0rvLKQiePGT5'
    json_string = JSON.parse(result.body)
    bd_lng = json_string['result']['location']['lng']
    bd_lat = json_string['result']['location']['lat']
    if place.nil?
      create_place(lonlat: gcj_02(bd_lng, bd_lat))
    else
      place.update(lonlat: gcj_02(bd_lng, bd_lat))
    end
    #更新机构课程课程的地址
    Sku.where(service_id: id).update_all(address: profile.address.to_s, coordinate: gcj_02(bd_lng, bd_lat))
  end

  def gcj_02(bd_lng, bd_lat)
    x, y = bd_lng - 0.0065, bd_lat - 0.006
    z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * Math::PI)
    theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * Math::PI)
    "POINT(#{z * Math.cos(theta)} #{z * Math.sin(theta)})"
  end
end

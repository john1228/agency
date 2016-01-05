class Service<User
  default_scope { joins(:profile).where('profiles.identity' => 2) }
  after_save :location
  has_many :service_members, dependent: :destroy
  has_many :service_photos, foreign_key: :user_id, dependent: :destroy
  has_many :service_dynamics, foreign_key: :user_id, dependent: :destroy

  has_many :service_members, dependent: :destroy
  has_many :coaches, through: :service_members

  
  has_many :orders, foreign_key: :service_id
  has_many :members
  alias_attribute :service_id, :id

  include AASM
  aasm :state do
    state :approving, :initial => true
    state :rejected
    state :approved

    event :reject do
      transitions :from => :approving, :to => :rejected
    end
    event :approve do
      transitions :from => :approving, :to => :approved
    end
  end

  def name
    profile.name
  end

  def profile_address
    (profile.province||'') + (profile.city||'') + (profile.area||'') + (profile.address||'')
  end

  private
  def location
    begin
      conn = Faraday.new(:url => 'http://api.map.baidu.com')
      address_summary = ((profile.province.to_s + profile.city.to_s + profile.address.to_s).match(/(.+?)[弄号]/)).to_s
      result = conn.get '/geocoder/v2/', address: address_summary, output: 'json', ak: '61Vl2dO7CKCt0rvLKQiePGT5'
      json_string = JSON.parse(result.body)
      bd_lng = json_string['results']['location']['lng']
      bd_lat = json_string['results']['location']['lat']
      if place.nil?
        create_place(lonlat: gcj_02(bd_lng, bd_lat))
      else
        place.update(lonlat: gcj_02(bd_lng, bd_lat))
      end
      #更新机构课程课程的地址
      Sku.where(seller_id: coaches.pluck(:id) << id).update_all(address: profile.province.to_s + profile.city.to_s + profile.address.to_s, coordinate: gcj_02(bd_lng, bd_lat))
    rescue
      #ignore sometimes not found location
    end
  end

  def gcj_02(bd_lng, bd_lat)
    x, y = bd_lng - 0.0065, bd_lat - 0.006
    z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * Math::PI)
    theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * Math::PI)
    "POINT(#{z * Math.cos(theta)} #{z * Math.sin(theta)})"
  end
end

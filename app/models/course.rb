class Course < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :coach
  has_many :lessons, dependent: :destroy
  has_many :concerns, class_name: Concerned, dependent: :destroy
  has_many :order_items
  attr_accessor :address
  after_save :sku_build

  STATUS = {offline: 0, online: 1}
  GUARANTEE = 1
  mount_uploaders :image, ImagesUploader
  validates_presence_of :image

  def as_json
    {
        id: id,
        name: name,
        type: type,
        style: style,
        during: during,
        price: price,
        exp: exp,
        proposal: proposal,
        intro: intro,
        guarantee: guarantee,
        address: school_addresses,
        images: image.map { |image| image.thumb.url },
        purchased: order_items_count,
        concerns: concerns_count
    }
  end

  def cover
    image.first.thumb.url
  end

  def school_addresses
    [
        {
            venues: coach.service.profile.name,
            address: coach.service.profile.address
        }
    ]
  end

  def type_name
    (INTERESTS['items'].detect { |item| item['id']==type })['name']
  end

  private
  def sku_build
    if status.eql?(STATUS[:online])
      Sku.destroy_all("sku LIKE 'CC%' and course_id = #{id}")
      Sku.create(
          sku: 'CC' + '-' + '%06d' % id + '-' + '%06d' % (coach.service.id),
          course_id: id,
          course_type: type,
          course_name: name,
          course_cover: cover,

          seller: coach.profile.name,
          seller_id: coach.id,

          market_price: price,
          selling_price: price,
          address: coach.service.profile.address||'',
          coordinate: (coach.service.place.lonlat rescue 'POINT(0 0)'),
          status: STATUS[:online]
      )
    else
      Sku.where("sku LIKE 'CC%' and course_id = #{id}").update_all(status: STATUS[:offline])
    end
  end
end

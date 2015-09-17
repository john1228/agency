class Lesson < ActiveRecord::Base
  belongs_to :user
  belongs_to :coach
  belongs_to :course
  belongs_to :order
  has_many :appointments
  before_create :build_code

  def as_json
    sku_info = Sku.find_by(sku: sku)
    {
        id: id,
        course: sku_info.course.name,
        student: user.profile.name,
        seller: sku_info.seller,
        available: available,
        used: appointments.pluck(:code)
    }
  end

  def detail
    sku_info = Sku.find_by(sku: sku)
    json_hash = {
        id: id,
        course: sku_info.course.name,
        seller: sku_info.seller,
        seller_type: sku.start_with?('CC') ? 'coach' : 'service',
        available: available,
        used: appointments.pluck(:code),
        during: sku_info.course.during,
        exp: exp,
        class_time: '',
        address: sku_info.related_sellers,
        qr_code: code
    }
    if sku_info.course.has_attribute?(:limit_start)&&sku_info.course.limit_start.present?
      json_hash = json_hash.merge(
          class_time:
              {
                  start: sku_info.course.limit_start.strftime('%Y-%m-%d %H:%M'),
                  end: sku_info.course.limit_end.strftime('%Y-%m-%d %H:%M')
              }
      )
    else
      json_hash = json_hash.merge(class_time: {start: '', end: ''})
    end
    json_hash
  end

  private
  def build_code
    self.code = (1..available).map { |index|
      'L'+('%05d' % user_id) + ('%04d' % order_id) + ('%02d' % index)
    }
  end
end

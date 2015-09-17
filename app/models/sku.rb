class Sku < ActiveRecord::Base
  scope :online, -> { where(status: 1) }
  scope :coach_courses, -> { where('sku LIKE ?', 'CC%') }
  scope :service_courses, -> { where('sku LIKE ?', 'SC%') }
  scope :recommended, -> { joins(:recommend).order('recommends.id desc') }
  has_one :recommend, -> { where(type: Recommend::TYPE[:course]).order(id: :desc) }, foreign_key: :recommended_id

  before_save :offline
  before_create :injection

  def as_json
    {
        sku: sku,
        name: course_name,
        seller: seller,
        cover: course_cover,
        selling: selling_price.to_i,
        guarantee: course_guarantee,
        address: address,
        store: store,
        distance: attributes['distance']||0,
        coordinate: {
            lng: coordinate.x,
            lat: coordinate.y
        }
    }
  end

  def detail
    json_hash = {
        sku: sku,
        name: course.name,
        images: course.image.map { |item| {thumb: item.thumb.url, original: item.url} },
        guarantee: course.guarantee,
        market: market_price.to_i,
        selling: selling_price.to_i,
        store: store||-1,
        score: score == 0 ? 4 : score,
        type: course.type,
        style: course.style,
        during: course.during,
        exp: Date.today.next_day(course.exp).strftime('%Y-%m-%d'),
        proposal: course.proposal,
        seller: {
            mxid: seller_user.profile.mxid,
            name: seller_user.profile.name,
            avatar: seller_user.profile.avatar.thumb.url,
            mobile: seller_user.is_a?(Coach) ? seller_user.mobile : seller_user.profile.mobile,
            identity: seller_user.profile.identity,
            tags: seller_user.profile.tags
        },
        address: [{
                      name: address,
                      agency: seller_user.is_a?(Coach) ? seller_user.service.profile.name : seller_user.profile.name,
                      coordinate: {
                          lng: coordinate.x,
                          lat: coordinate.y
                      }
                  }],
        intro: course.intro,
        special: course.special,
        service: seller_user.is_a?(Service) ? seller_user.profile.service : seller_user.service.profile.service,
        buyers: {
            count: orders_count,
            items: buyers
        },
        status: status,
        comments: [
            count: comments.count,
            items: image_comments.take(5)
        ]
    }
    json_hash = json_hash.merge(limit_time: {start: course.limit_start.strftime('%Y-%m-%d %H:%M'), end: course.limit_end.strftime('%Y-%m-%d %H:%M')}) if course.has_attribute?(:limit_start)&&course.limit_start.present?
    json_hash
  end

  def course
    if sku.start_with?('SC')
      ServiceCourse.find_by(id: course_id)
    else
      Course.find_by(id: course_id)
    end
  end

  def related_sellers
    Sku.where('sku LIKE ? and course_id=?', sku[0, 2] + '%', course_id).map { |sku|
      seller_user = sku.seller_user
      {
          seller: seller_user.is_a?(Service) ? seller_user.profile.name : seller_user.service.profile.name,
          address: sku.address,
          tel: seller_user.is_a?(Service) ? seller_user.profile.mobile : seller_user.mobile,
          coordinate: {
              lng: sku.coordinate.x,
              lat: sku.coordinate.y
          }
      }
    }
  end

  def score
    Comment.where('sku LIKE ?', sku[0, sku.rindex('-')] + '%').average(:score).to_f.round(2)
  end

  def image_comments
    Comment.where('sku LIKE ? and array_length(image,1)>0', sku[0, sku.rindex('-')] + '%').order(id: :desc)
  end

  def comments
    Comment.where('sku LIKE ?', sku[0, sku.rindex('-')] + '%').order(id: :desc)
  end

  def limit_detect(user)
    Order.includes(:order_item).where(status: [Order::STATUS[:unpaid], Order::STATUS[:pay], Order::STATUS[:finish]]).where('orders.user_id=? AND order_items.sku LIKE ?', user, sku[0, sku.rindex('-')] + '%').sum('order_items.amount')
  end

  def buyers
    User.where(id: Order.includes(:order_item).where('orders.status = ? and order_items.sku LIKE ?', Order::STATUS[:pay], sku[0, sku.rindex('-')] + '%').order(id: :desc).pluck(:user_id)).limit(5).map { |user|
      {
          mxid: user.profile.mxid,
          name: user.profile.name,
          avatar: user.profile.avatar.thumb.url
      }
    }
  end

  def seller_user
    if sku.start_with?('SC')
      user = Service.find_by(id: seller_id)
    else
      user = Coach.find_by(id: seller_id)
    end
    user
  end

  protected
  def offline
    self.status = 0 if store.eql?(0)
  end

  def injection
    self.orders_count = rand(100)
  end
end

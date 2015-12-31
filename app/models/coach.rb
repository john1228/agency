class Coach<User

  default_scope { joins(:profile).where('profiles.identity' => 1) }
  scope :recommended, -> { joins(:recommend).order('recommends.id desc') }
  has_many :coach_docs, dependent: :destroy
  has_many :coach_dynamics, foreign_key: :user_id, dependent: :destroy
  has_many :coach_photos, foreign_key: :user_id, dependent: :destroy
  has_many :coach_tracks, foreign_key: :user_id, dependent: :destroy


  has_many :orders, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many :lessons, dependent: :destroy

  has_one :service_member, dependent: :destroy
  has_one :service, through: :service_member
  has_one :recommend, -> { where(type: Recommend::TYPE[:person]) }, foreign_key: :recommended_id

  has_many :discounts, class: CoachDiscount
  has_one :default_discount, class: CoachDiscountDefault
  validates_presence_of :mobile, message: '请填写手机号'
  validates_uniqueness_of :mobile, message: '该手机号已经注册'
  validates_format_of :mobile, with: /^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/, multiline: true, message: '无效到手机号码'


  accepts_nested_attributes_for :profile

  def score
    sku_array = courses.pluck(:id).map { |id| 'CC' + '-' + '%06d' % id + '-' + '%06d' % (service.id) }
    Comment.where(sku: sku_array).average(:score)
  end

  def comments
    sku_array = Sku.online.where('skus.sku LIKE ?', 'CC%').where(seller_id: id).pluck(:sku)
    Comment.where(sku: sku_array).order(id: :desc)
  end

  def detail
    detail = {
        mxid: profile.mxid,
        name: HarmoniousDictionary.clean(profile.name),
        avatar: profile.avatar.url,
        tag: profile.tags,
        gender: profile.gender||1,
        age: profile.age,
        photowall: photos,
        score: score,
        likes: likes.count,
        dynamics: dynamics.count,
        signature: profile.signature,
        address: service.profile.address,
        service: {
            mxid: service.profile.mxid,
            name: service.profile.name,
        },
        skill: _skill,
        course: {
            amount: Sku.online.where(seller_id: id).count,
            item: Sku.online.where(seller_id: id).order(updated_at: :desc).take(2).map { |item|
              {
                  sku: item.sku,
                  name: item.course_name,
                  cover: item.course_cover,
                  selling: item.selling_price.to_i
              }
            }
        },
        comment: {
            amount: comments.count,
            item: comments.take(2)
        },
        contact: mobile
    }

    detail = detail.merge(showtime: {
                              cover: showtime.dynamic_film.cover,
                              film: showtime.dynamic_film.film.hls
                          }) if showtime.present?
    detail
  end

  def addresses
    if service.blank?
      []
    else
      [
          {
              id: service.profile.id,
              venues: service.profile.name,
              address: service.profile.province||''+ service.profile.city||'' + service.profile.area||'' + service.profile.address
          }
      ]
    end
  end

  private
  def _skill
    interests_ary = interests.split(',') rescue []
    choose_interests = INTERESTS['items'].select { |item| interests_ary.include?(item['id'].to_s) }
    choose_interests.collect { |choose| choose['name'] }
  end
end
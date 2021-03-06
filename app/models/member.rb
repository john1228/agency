class Member < ActiveRecord::Base
  enum gender: [:male, :female]
  enum origin: [:mxing, :input]
  enum member_type: [:associate, :full, :coach]
  #validates :name, :birthday, :gender, :mobile, :service_id, :province, :city, :area, :address, :avatar, presence: true
  mount_uploader :avatar, ProfileUploader

  belongs_to :service
  belongs_to :user

  has_many :cards, class: MembershipCard, dependent: :destroy
  has_many :logs, class: MemberLog, dependent: :destroy
  validates :name, :mobile, presence: true
  validates_uniqueness_of :mobile, scope: :service_id

  before_create :valid_user

  protected
  def valid_user
    if user.blank?
      user = User.find_by(mobile: mobile)
      if user.present?
        self.user_id = user.id
      else
        build_user(mobile: mobile, sns: SecureRandom.uuid, password: '12345678', profile_attributes: {
                                     name: name,
                                     avatar: avatar,
                                     gender: gender,
                                     birthday: birthday,
                                     province: province,
                                     city: city,
                                     area: area,
                                     address: address
                                 })
      end
    end
  end
end

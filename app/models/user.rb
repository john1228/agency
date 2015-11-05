class User < ActiveRecord::Base
  default_scope { where(status: 1) }
  has_one :profile, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :dynamics, dependent: :destroy
  has_many :dynamic_comments, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_one :place, dependent: :destroy
  has_one :showtime
  has_many :applies
  has_many :likes, -> { where(like_type: Like::PERSON) }, foreign_key: :liked_id, dependent: :destroy
  #v3
  has_one :wallet, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :concerns, class_name: Concerned, dependent: :destroy

  accepts_nested_attributes_for :profile
  accepts_nested_attributes_for :photos

  TYPE=[['健身爱好者', 0], ['私教', 1], ['商家', 2]]
  before_save :encrypted_password

  def mxid
    profile.id + 10000
  end
  class<<self
    def find_by_mxid(mxid)
      includes(:profile).where('profiles.id' => ((mxid.to_i - 10000))).first
    end
  end

  def token
    Digest::MD5.hexdigest("#{id}")
  end

  private
  def encrypted_password
    if password.present? && password.length==32
    else
      salt_arr = %w"a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9"
      self.salt = salt_arr.sample(18).join
      self.password = Digest::MD5.hexdigest("#{password}|#{self.salt}")
    end
  end
end

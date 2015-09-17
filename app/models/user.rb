class User < ActiveRecord::Base
  include UserAble
  has_one :profile, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :dynamics, dependent: :destroy
  has_many :dynamic_comments, dependent: :destroy
  has_many :tracks, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_one :place, dependent: :destroy
  has_one :showtime
  has_many :applies
  has_many :likes, -> { where(like_type: Like::PERSON) }, foreign_key: :liked_id, dependent: :destroy

  attr_accessor :name, :avatar, :gender, :signature, :identity, :birthday, :address, :target, :skill, :often, :interest, :interests, :contact, :service
  alias_attribute :hobby, :interests
  attr_accessor :new

  #v3
  has_one :wallet, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :concerns, class_name: Concerned, dependent: :destroy
  has_one :setting, dependent: :destroy


  TYPE=[['健身爱好者', 0], ['私教', 1], ['商家', 2]]
  class<<self
    def find_by_mxid(mxid)
      includes(:profile).where('profiles.id' => ((mxid.to_i - 10000))).first
    end
  end

  def token
    Digest::MD5.hexdigest("#{id}")
  end

  def summary_json
    regular = /^1[3|4|5|7|8][0-9]\d{4,8}$/
    if regular.match(mobile).blank?
      login_info = profile.summary_json.merge(mobile: '', token: token)
    else
      login_info = profile.summary_json.merge(mobile: mobile[0, 3]+'****'+ mobile[7, 4], token: token)
    end
    login_info.merge(new: new.present? ? 1 : 0)
  end

  def as_json
    case profile.identity
      when 0
        profile.as_json.merge(likes: likes.count)
      when 1
        profile.as_json.merge(likes: likes.count, mobile: mobile)
      when 2
        profile.as_json.merge(likes: likes.count, mobile: profile.mobile)
    end
  end


  def self.search(attendance_level, options = {})
    puts attendance_level, options
  end
end

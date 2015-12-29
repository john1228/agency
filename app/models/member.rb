class Member < ActiveRecord::Base
  enum gender: [:male, :female]
  enum origin: [:mxing, :input]
  enum member_type: [:associate, :full]
  validates :name, :birthday, :gender, :mobile, :service_id, :province, :city, :area, :address, :avatar, presence: true
  mount_uploader :avatar, ProfileUploader

  belongs_to :service
  belongs_to :user
end

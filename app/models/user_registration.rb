class UserRegistration < ActiveRecord::Base
  enum gender: [:male, :female]
  enum source: [:meixing, :input]

  mount_uploader :avatar, ProfileUploader

  validates :name,:birthday,:gender,:mobile,:service_id,:province,:city,:address,:avatar, presence: true
end

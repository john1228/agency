class UserRegistration < ActiveRecord::Base
  enum gender: [:male, :female]
  enum source: [:meixing, :input]
end

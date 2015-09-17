class Friend < ActiveRecord::Base
  validates_presence_of :friend_id, :message => 'Please choose your friend.'
  validates_uniqueness_of :friend_id, :scope => :user_id, :message => 'The user has been your friend.'
  belongs_to :user
end

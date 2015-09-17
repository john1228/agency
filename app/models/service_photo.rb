class ServicePhoto<Photo
  belongs_to :service, foreign_key: :user_id
end
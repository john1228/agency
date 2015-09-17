class CoachPhoto<Photo
  belongs_to :coach, foreign_key: :user_id
end
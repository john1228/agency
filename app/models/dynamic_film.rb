class DynamicFilm < ActiveRecord::Base
  belongs_to :dynamic
  validates_presence_of :cover, message: '封面不能为空'
  validates_presence_of :film, message: '视频不能为空'

  mount_uploader :cover, FilmCoverUploader
  mount_uploader :film, FilmUploader
end

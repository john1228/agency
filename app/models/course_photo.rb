class CoursePhoto < ActiveRecord::Base
  belongs_to :course
  mount_uploader :photo, PhotosUploader
end

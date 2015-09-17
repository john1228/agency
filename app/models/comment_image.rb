class CommentImage < ActiveRecord::Base
  belongs_to :comment
  mount_uploader :image, ImagesUploader
end

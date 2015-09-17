class DynamicImage < ActiveRecord::Base
  belongs_to :dynamic
  mount_uploader :image, DynamicImagesUploader
end

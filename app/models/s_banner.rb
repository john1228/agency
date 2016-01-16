class SBanner < ActiveRecord::Base
  belongs_to :service

  mount_uploaders :pos_1, ImagesUploader
  mount_uploaders :pos_2, ImagesUploader
  mount_uploaders :pos_3, ImagesUploader

  validates :service_id, :pos_1, :pos_2, :pos_3, presence: :true
end

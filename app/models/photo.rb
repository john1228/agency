class Photo < ActiveRecord::Base
  default_scope -> { limit(6) }
  belongs_to :user
  mount_uploader :photo, PhotosUploader

  def as_json
    {
        no: id,
        thumb: photo.thumb.url,
        original: photo.url
    }
  end
end

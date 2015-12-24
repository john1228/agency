# encoding: utf-8
class ImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :qiniu

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
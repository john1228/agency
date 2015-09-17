# encoding: utf-8
class GalleryUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file
  process :resize_to_limit => [2080, 2080]

  def store_dir
    'images/gallery'
  end

  version :thumb do
    process :resize_to_fit => [220, 220]
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  def filename
    "#{Time.now.strftime('%Y/%m/%d')}/#{secure_token}.#{file.extension}" if original_filename
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end

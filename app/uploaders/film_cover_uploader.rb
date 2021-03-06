# encoding: utf-8

class FilmCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :qiniu

  def store_dir
    "images/#{model.class.to_s.underscore}"
  end

  def default_url
    "#{$host}/images/default/cover.png"
  end


  version :thumb do
    process :resize_to_fit => [200, 200]
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

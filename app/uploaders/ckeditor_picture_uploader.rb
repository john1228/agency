# encoding: utf-8
class CkeditorPictureUploader < CarrierWave::Uploader::Base
  include Ckeditor::Backend::CarrierWave
  include CarrierWave::MiniMagick
  storage :file
  process :read_dimensions

  def store_dir
    "uploads/ckeditor/pictures/#{model.class.to_s.underscore}"
  end

  def filename
    "#{Time.now.strftime('%Y/%m/%d')}/#{secure_token}.#{file.extension}" if original_filename
  end

  version :thumb do
    process :resize_to_fit => [118, 100]
  end


  version :content do
    process :resize_to_limit => [800, 800]
  end

  def extension_white_list
    Ckeditor.image_file_types
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end

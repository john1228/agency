# encoding: utf-8
class ImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :qiniu
  process :resize_to_limit => [1024, 1024]

  def store_dir
    'images'
  end

  def filename
    "#{Time.now.strftime('%Y/%m/%d')}/#{secure_token}.#{file.extension}" if original_filename
  end

  private
  def secure_token
    Digest::MD5::hexdigest(current_path)
  end
end
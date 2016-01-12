# encoding: utf-8

class ProductImagesUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :qiniu
  process :resize_to_limit => [1024, 1024]
  after :store, :update_relation_sku

  def store_dir
    'images/course'
  end

  def filename
    "#{Time.now.strftime('%Y/%m/%d')}/#{secure_token}.#{file.extension}" if original_filename
  end

  private
  def secure_token
    Digest::MD5::hexdigest(current_path)
  end

  def update_relation_sku(args)
    image_index = model.image.index(self)
    model.sku.update(course_cover: url) if image_index.eql?(0)
  end
end

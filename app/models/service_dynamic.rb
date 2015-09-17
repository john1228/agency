class ServiceDynamic<Dynamic
  after_create :save_images
  belongs_to :service, foreign_key: :user_id
  attr_accessor :images

  private
  def save_images
    images.map { |image|
      dynamic_images.create(image: image)
    } unless images.nil?
  end
end
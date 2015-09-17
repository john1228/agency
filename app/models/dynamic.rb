class Dynamic < ActiveRecord::Base
  belongs_to :user
  after_save :check_images

  has_many :dynamic_images, dependent: :destroy
  has_one :dynamic_film, dependent: :destroy
  has_many :dynamic_comments, dependent: :destroy
  has_many :likes, -> { where(like_type: Like::DYNAMIC) }, foreign_key: :liked_id, dependent: :destroy

  accepts_nested_attributes_for :dynamic_images
  accepts_nested_attributes_for :dynamic_film

  attr_accessor :img_1, :img_2, :img_3, :img_4, :img_5, :img_6, :img_7, :img_8
  validates_presence_of :user_id

  TOP = 1
  class<<self
    def latest
      order(id: :desc).first
    end
  end

  def as_json
    json_hash = {
        no: id,
        content: HarmoniousDictionary.clean(content || ''),
        created: created_at.to_i,
        likes: likes.count,
        like_user: likes.includes(:user).order(id: :desc).limit(15).map{|like| like.as_json},
        comments: {
            count: dynamic_comments.count,
            item: dynamic_comments.order(id: :desc).limit(2).collect { |comment| comment.as_json }
        }
    }
    json_hash = json_hash.merge({
                                    images: dynamic_images.collect { |dynamic_image|
                                      {
                                          thumb: dynamic_image.image.thumb.url,
                                          original: dynamic_image.image.url,
                                          width: dynamic_image.width,
                                          height: dynamic_image.height
                                      }
                                    }
                                }) unless dynamic_images.blank?
    json_hash = json_hash.merge({
                                    film: {
                                        cover: dynamic_film.cover.thumb.url,
                                        film: dynamic_film.film.hls
                                    }
                                }) unless dynamic_film.blank?
    json_hash
  end


  def summary_json
    image = dynamic_images.first.image rescue nil
    image = dynamic_film.cover if image.blank? && dynamic_film.present?
    {
        content: HarmoniousDictionary.clean(content||''),
        image: image.present? ? image.thumb.url : ''
    }
  end

  private
  def check_images
    dynamic_images.create(image: img_1) unless img_1.blank?
    dynamic_images.create(image: img_2) unless img_2.blank?
    dynamic_images.create(image: img_3) unless img_3.blank?
    dynamic_images.create(image: img_4) unless img_4.blank?
    dynamic_images.create(image: img_5) unless img_5.blank?
    dynamic_images.create(image: img_6) unless img_6.blank?
    dynamic_images.create(image: img_7) unless img_7.blank?
    dynamic_images.create(image: img_8) unless img_8.blank?
  end
end

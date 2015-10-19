class Dynamic < ActiveRecord::Base
  belongs_to :user
  has_many :comments, class_name: DynamicComment, dependent: :destroy
  has_many :film, class_name: DynamicFilm, dependent: :destroy
  has_many :images, class_name: DynamicImage, dependent: :destroy
  has_many :likes, -> { where(like_type: Like::DYNAMIC) }, foreign_key: :liked_id, dependent: :destroy

  accepts_nested_attributes_for :images
  accepts_nested_attributes_for :film
  validates_presence_of :images, if: Proc.new { |dynmamic| dynmamic.film.blank? }, message: '图片或者视频二者不能同时为空'
  TOP = 1
end

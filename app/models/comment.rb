class Comment < ActiveRecord::Base
  default_scope { order(id: :desc) }
  belongs_to :user
  mount_uploaders :image, ImagesUploader
  after_create :update_count

  def as_json
    {
        content: HarmoniousDictionary.clean(content),
        score: score,
        images: image.map { |item|
          {
              thumb: item.thumb.url,
              original: item.url
          }
        },
        user: user.profile.summary_json,
        created: created_at.to_i
    }
  end

  private
  def update_count
    Sku.where('sku LIKE ?', sku[0, sku.rindex('-')] + '%').update_all('comments_count = comments_count + 1')
  end
end

class Showtime<Dynamic
  before_create :build_film
  default_scope { where(top: 1).order(id: :desc) }
  belongs_to :user
  attr_accessor :title
  attr_accessor :cover
  attr_accessor :film

  def as_json
    {
        no: id,
        title: dynamic_film.title,
        film: {
            cover: dynamic_film.cover.thumb.url,
            film: dynamic_film.film.hls
        },
        likes: likes.count,
        comments: dynamic_comments.count
    }
  end

  private
  def build_film
    build_dynamic_film(title: title, cover: cover, film: film)
    true
  end
end
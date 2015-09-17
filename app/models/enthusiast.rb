class Enthusiast<User
  default_scope { joins(:profile).where('profiles.identity' => 0) }

  def detail
    detail = {
        mxid: profile.mxid,
        name: profile.name,
        avatar: {
            thumb: profile.avatar.thumb.url,
            origin: profile.avatar.url
        },
        tag: profile.tags,
        address: profile.address,
        intro: profile.signature,
        likes: likes.count,
        photowall: photos,
        target: profile.target,
        hobby: _hobby,
        often: profile.often_stadium,
        skill: profile.skill,
        dynamic: dynamics.order(id: :desc).page(1).map { |dynamic|
          json_str = {
              id: dynamic.id,
              content: dynamic.content
          }
          json_str = json_str.merge(image: dynamic.dynamic_images.first.image.thumb.url) if dynamic.dynamic_images.present?
          json_str = json_str.merge(film: dynamic.dynamic_film.cover.thumb.url) if dynamic.dynamic_film.present?
          json_str
        }
    }
    detail = detail.merge(showtime: {
                              cover: showtime.dynamic_film.cover,
                              film: showtime.dynamic_film.film.hls
                          }) if showtime.present?
    detail
  end

  private
  def _hobby
    interests_ary = interests.split(',') rescue []
    choose_interests = INTERESTS['items'].select { |item| interests_ary.include?(item['id'].to_s) }
    choose_interests.collect { |choose| choose['name'] }
  end
end
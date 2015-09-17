module UserAble
  extend ActiveSupport::Concern
  included do
    before_create :build_default_profile
    before_save :encrypted_password
    after_update :update_profile
  end

  private
  def build_default_profile
    if avatar.is_a?(String)
      build_profile(
          name: name,
          remote_avatar_url: avatar,
          gender: identity.eql?(2) ? 2 : (gender||1),
          signature: signature||'这家伙很懒,什么也没留下',
          identity: identity||0,
          birthday: birthday,
          address: address||'',
          target: target||'',
          skill: skill||'',
          often: often||'',
          service: service,
          interests: (interest.join(',') rescue ''),
          mobile: mobile.to_s.length.eql?(13) ? mobile : contact
      )
    else
      build_profile(
          name: name,
          avatar: avatar,
          gender: identity.eql?(2) ? 2 : (gender||1),
          signature: signature||'这家伙很懒,什么也没留下',
          identity: identity||0,
          birthday: birthday,
          address: address||'',
          target: target||'',
          skill: skill||'',
          often: often||'',
          service: service,
          interests: (interest.join(',') rescue ''),
          mobile: mobile.to_s.length.eql?(13) ? mobile : contact
      )
    end
    true
  end

  def encrypted_password
    if password.present? && password.length==32
    else
      salt_arr = %w"a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9"
      self.salt = salt_arr.sample(18).join
      self.password = Digest::MD5.hexdigest("#{password}|#{self.salt}")
    end
  end

  def update_profile
    update_avatar = avatar
    update_params = {
        name: name||profile.name,
        gender: gender||profile.gender,
        signature: signature||'这家伙很懒,什么也没留下',
        birthday: birthday||'',
        address: address||profile.address,
        target: target||profile.target,
        skill: skill||profile.skill,
        often: often||profile.often,
        identity: identity||profile.identity,
        interests: (interest.join(',') rescue nil)||profile.interests,
        service: service,
        mobile: mobile
    }
    update_params = update_params.merge(avatar: update_avatar) if update_avatar.present?
    update_params = update_params.merge(mobile: contact) if contact.present?
    profile.update(update_params)
  end
end
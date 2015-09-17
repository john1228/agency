module GroupAble
  extend ActiveSupport::Concern
  included do
    after_create :regist_to_easemob
    before_destroy :delete_group
    before_create :build_default_place

    has_many :group_photos, dependent: :destroy
    has_many :group_members, dependent: :destroy
    has_one :group_place, dependent: :destroy
  end


  private
  def regist_to_easemob
    access_token = Rails.cache.fetch('mob')
    result = Faraday.post { |req|
      req.url "#{MOB['host']}/chatgroups"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{access_token}"
      req.body = {groupname: name, desc: intro, public: true, maxusers: 100, approval: true, owner: "#{owner}"}.to_json.to_s
    }
    self.easemob_id = JSON.parse(result.body).fetch('data').fetch('groupid')
    self.save
  end

  def delete_group
    access_token = Rails.cache.fetch('mob')
    Faraday.delete do |req|
      req.url "#{MOB['host']}/chatgroups/#{easemob_id}"
      req.headers['Authorization'] = "Bearer #{access_token}"
    end
  end

  def build_default_place
    if lng.blank? || lat.blank?
      place = (User.find_by_mxid(owner).place.lonlat rescue nil)
    else
      place = "POINT(#{lng} #{lat})"
    end
    build_group_place(lonlat: place)
    true
  end
end
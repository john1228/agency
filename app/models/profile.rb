class Profile < ActiveRecord::Base
  after_create :regist_to_easemob
  after_destroy :delete_from_easemob
  mount_uploader :avatar, ProfileUploader
  belongs_to :user
  TAGS = %w(会员 认证 私教)

  validates_presence_of :name, if: Proc.new { |profile| profile.identity.eql?(1) }, message: '名字不能为空'
  validates_presence_of :avatar, if: Proc.new { |profile| profile.identity.eql?(1) }, message: '头像不能为空'
  validates_presence_of :birthday, if: Proc.new { |profile| profile.identity.eql?(1) }, message: '生日不能为空'
  validates_presence_of :gender, if: Proc.new { |profile| profile.identity.eql?(1) }, message: '性别不能为空'
  validates_presence_of :hobby, if: Proc.new { |profile| profile.identity.eql?(1) }, message: '健身服务不能为空'


  BASE_NO = 10000
  class << self
    def find_by_mxid(mxid)
      find_by(id: mxid.to_i - BASE_NO)
    end
  end

  def age
    if birthday.blank?
      0
    else
      years = Date.today.year - birthday.year
      years + (Date.today < birthday + years.year ? -1 : 0)
    end
  end

  def hobby_string
    choose_interests = INTERESTS['items'].select { |item| hobby.include?(item['id']) }
    (choose_interests.map { |choose| choose['name'] }).join('/')
  end

  def tags
    [0, identity.eql?(2) ? 1 : 0, identity.eql?(1) ? 1 : 0]
  end

  def mxid
    BASE_NO + id
  end

  private
  def regist_to_easemob
    easemob_token = Rails.cache.fetch('mob')
    Faraday.post do |req|
      req.url "#{MOB['host']}/users"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body = "{\"username\": \"#{mxid}\", \"password\": \"123456\", \"nickname\": \"#{name}\"}"
    end
  end

  def delete_from_easemob
    easemob_token = Rails.cache.fetch('mob')
    Faraday.delete do |req|
      req.url "#{MOB['host']}/users/#{mxid}"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{easemob_token}"
      req.body = ''
    end
  end
end

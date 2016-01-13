class Profile < ActiveRecord::Base
  belongs_to :user
  enum gender: [:male, :female]
  after_create :regist_to_easemob
  after_destroy :delete_from_easemob
  mount_uploader :avatar, ProfileUploader
  validates_presence_of :name, message: '名字不能为空'
  validates_presence_of :avatar, if: Proc.new { |profile| profile.coach? }, message: '头像不能为空'
  validates_presence_of :birthday, if: Proc.new { |profile| profile.coach? }, message: '生日不能为空'
  validates_presence_of :gender, if: Proc.new { |profile| profile.coach? }, message: '性别不能为空'
  validates_presence_of :hobby, if: Proc.new { |profile| profile.coach? }, message: '健身服务不能为空'
 

  validates_presence_of :name, if: Proc.new { |profile| profile.service? }, message: '名字不能为空'
  validates_presence_of :avatar, if: Proc.new { |profile| profile.service? }, message: '头像不能为空'
  validates_presence_of :signature, if: Proc.new { |profile| profile.service? }, message: '介绍不能为空'
  validates_presence_of :province, if: Proc.new { |profile| profile.service? }, message: '省份不能为空'
  validates_presence_of :city, if: Proc.new { |profile| profile.service? }, message: '城市不能为空'
  validates_presence_of :address, if: Proc.new { |profile| profile.service? }, message: '详细地址不能为空'
  validates_presence_of :hobby, if: Proc.new { |profile| profile.service? }, message: '服务项目不能为空'
  validates_presence_of :mobile, if: Proc.new { |profile| profile.service? }, message: '联系电话不能为空'

  enum identity: [:enthusiast, :coach, :service]

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

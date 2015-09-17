module ProfileAble
  extend ActiveSupport::Concern
  included do
    after_create :regist_to_easemob
    after_destroy :delete_from_easemob
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
    MessageJob.set(wait: 1.minute).perform_later(id, MESSAGE['欢迎语'])
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
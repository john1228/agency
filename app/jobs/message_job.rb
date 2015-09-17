class MessageJob < ActiveJob::Base
  queue_as :default

  def perform(user_id, message)
    profile = Profile.find_by(id: user_id)
    access_token = Rails.cache.fetch('mob')
    Faraday.post do |req|
      req.url "#{MOB['host']}/messages"
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{access_token}"
      req.body = {target_type: 'users', target: ["#{profile.mxid}"], msg: {type: 'txt', msg: message}}.to_json.to_s
    end
  end
end

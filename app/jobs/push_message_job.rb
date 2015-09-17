class PushMessageJob < ActiveJob::Base
  queue_as :default

  def perform(from, to, message)
    access_token = Rails.cache.fetch('mob')
    if to.eql?('all')
      user = Profile.where.not(identity: 2)
      (0..(user.size/20)).map { |index|
        mxids = user.page(index+1).pluck(:id).map { |id| "#{Profile::BASE_NO + id}" }
        Faraday.post do |req|
          req.url "#{MOB['host']}/messages"
          req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = "Bearer #{access_token}"
          req.body = from.eql?('mxing') ? {target_type: 'users', target: mxids, msg: {type: 'txt', msg: message}}.to_json.to_s :
              {target_type: 'users', target: mxids, msg: {type: 'txt', msg: message}, from: from}.to_json.to_s
        end if mxids.present?
        sleep(0.05)
      }
    else
      user = to.is_a?(Array) ? to : to.split(',')
      (0..(user.size/2)).map { |index|
        mxids = user[index*20, 20]
        Faraday.post do |req|
          req.url "#{MOB['host']}/messages"
          req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = "Bearer #{access_token}"
          req.body = from.eql?('mxing') ? {target_type: 'users', target: mxids, msg: {type: 'txt', msg: message}}.to_json.to_s :
              {target_type: 'users', target: mxids, msg: {type: 'txt', msg: message}, from: from}.to_json.to_s
        end if mxids.present?
        sleep(0.05)
      }
    end
  end
end

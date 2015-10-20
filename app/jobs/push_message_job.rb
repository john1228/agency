class PushMessageJob < ActiveJob::Base
  queue_as :default

  def perform(from, groups, message)
    access_token = Rails.cache.fetch('mob')
    from_user = User.find_by_mxid(from)
    groups = MassMessageGroup.where(id: groups)
    groups.map { |group|
      users = User.where(id: group.user_id).map { |user| "#{user.profile.mxid}" }
      (0..(users.size/20)).each { |index|
        mxids = users[index*20, 20]
        Faraday.post do |req|
          req.url "#{MOB['host']}/messages"
          req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = "Bearer #{access_token}"
          req.body = {target_type: 'users', target: mxids, msg: {type: 'txt', msg: message}, from: from_user.profile.mxid}.to_json.to_s
        end if mxids.present?
        sleep(0.05)
      }
    }
  end
end

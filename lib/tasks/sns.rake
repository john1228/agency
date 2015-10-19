namespace :sns do
  desc '计算周like榜'
  task :qq => :environment do
    code = '38308E7AE37FF416351D0CA464DC80B3'
    oauth_consumer_key = '1103429959'
    conn = Faraday.new(url: 'https://graph.qq.com')
    me = conn.get 'oauth2.0/me', access_token: code
    puts me.body
    me_json = JSON.parse(me.body.gsub('callback( ', '').gsub(');', ''))
    openid = me_json['openid']
    userinfo_response = conn.get 'user/get_user_info ', access_token: code, oauth_consumer_key: oauth_consumer_key, openid: openid
    puts userinfo_response.body
  end

  task :apns do
    require 'houston'
    apn = Houston::Client.development
    apn.certificate = File.read("#{Rails.root}/config/certs/develop.pem")

    token = '95eb3467 2ef2b014 b79ca116 672f8d61 3d3add06 b0f72704 ca5a74c8 53a73949'
    notification = Houston::Notification.new(device: token)
    notification.alert = '这是外部消息'
    notification.badge = 57
    notification.category = 'INVITE_CATEGORY'
    notification.content_available = true
    notification.custom_data = {action: 1, page: {message: '这是一个测试消息'}}
    apn.push(notification)
    puts notification.error
  end
end
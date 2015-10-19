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
    apn = Houston::Client.production
    apn.certificate = File.read("#{Rails.root}/config/certs/production.pem")

    token = "c7c06762 5ca700f9 dd37f1ef 7e226418 7674c924 5d0689c9 a5500b10 fa4cf9c7"

    notification = Houston::Notification.new(device: token)
    notification.alert = '这是外部消息'

    notification.badge = 57
    notification.sound = "sosumi.aiff"
    notification.category = "INVITE_CATEGORY"
    notification.content_available = true
    notification.custom_data = {action: 1, page: {message: '这是内部消息'}}
    apn.push(notification)
    puts notification.error
  end
end
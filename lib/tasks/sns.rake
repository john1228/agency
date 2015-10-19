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
    apn.certificate = File.read("#{Rails.root}/config/certs/apns_production.pem")

    token = ['8a36f1f4 9cdf620b d1c21e4f a7557b88 643684a3 7543c104 d49d9ac3 a89e6146', 'c6d6e4b8 967f3182 7be9e4e4 f6c8b1d5 d544110e fc798c2c 342a3f09 e28612f4']
    token.each { |device|
      notification = Houston::Notification.new(device: device)
      notification.alert = '这是外部消息'
      notification.badge = 57
      notification.sound = 'sosumi.aiff'
      notification.category = 'INVITE_CATEGORY'
      notification.content_available = true
      notification.custom_data = {action: 1, page: {message: '这是一个测试消息'}}
      apn.push(notification)
      puts notification.error
    }
    puts apn.devices
  end
end
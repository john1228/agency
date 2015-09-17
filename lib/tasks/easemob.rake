namespace :easemob do

  desc '测试更新'
  task :create => :environment do
    token_response = Faraday.post do |req|
      req.url 'https://a1.easemob.com/jsnetwork/mxing/token'
      req.headers['Content-Type'] = 'application/json'
      req.body = '{"grant_type": "client_credentials", "client_id": "YXA6HPZzIHIkEeSy6P9lvafoPA", "client_secret": "YXA6GQOgkrCoDL61TY9IPzRcto4mJn4"}'
    end
    easemob_body = JSON.parse(token_response.body)
    easemob_token = easemob_body['access_token']
    puts "token::#{easemob_token}"
    User.all.each do |user|
      response = Faraday.post do |req|
        req.url 'https://a1.easemob.com/jsnetwork/mxing/users'
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Bearer #{easemob_token}"
        req.body = "{\"username\": \"#{user.username}\", \"password\": \"123456\", \"nickname\": \"#{user.profile.name}\"}"
      end
      puts response.body
    end
  end
end
namespace :mob do
  desc '计算周like榜'
  task :access_token => :environment do
    response = Faraday.post do |req|
      req.url "#{MOB['host']}/token"
      req.headers['Content-Type'] = 'application/json'
      req.body = {
          grant_type: 'client_credentials',
          client_id: MOB['client_id'],
          client_secret: MOB['client_secret']
      }.to_json.to_s
    end
    body = JSON.parse(response.body)
    Rails.cache.write('mob', body['access_token'])
  end
end
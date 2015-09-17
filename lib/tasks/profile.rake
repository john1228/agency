namespace :profile do
  desc '我的资料'
  task :show do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.get '/profile', mxid: 10001
    puts response.body
  end


  desc '测试更新'
  task :update => :environment do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.put '/profile', {signature: "测试更新"}
    puts response.body
  end

end
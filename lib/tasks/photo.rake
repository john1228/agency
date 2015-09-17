namespace :photos do

  desc '测试更新'
  task :index do
    host = 'http://192.168.0.111'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = "a87ff679a2f3e71d9181a67b7542122c"
    response = conn.get '/photos', mxid: 10004
    puts response.body
  end


  desc '测试添加'
  task :create do
    host = 'http://localhost'
    conn = Faraday.new(:url => host) do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
    end
    conn.headers['token'] = "a87ff679a2f3e71d9181a67b7542122c"
    response = conn.post '/photos', {loc: 0,
                                     photo: Faraday::UploadIO.new('/root/桌面/images/024f78f0f736afc3e9876f57b019ebc4b745127c.jpg', 'image/jpeg')}
    puts response.body
  end


  desc '测试更新'
  task :update do
    host = 'http://localhost'
    conn = Faraday.new(:url => host) do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
    end
    conn.headers['token'] = "a87ff679a2f3e71d9181a67b7542122c"
    response = conn.put '/photos', loc: 0,
                        photo: Faraday::UploadIO.new('/root/桌面/images/7a899e510fb30f24b96c3394ca95d143ac4b03b7.jpg', 'image/jpeg')
    puts response.body
  end


  desc '测试删除'
  task :delete do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = "a87ff679a2f3e71d9181a67b7542122c"
    response = conn.delete '/photos/0'
    puts response.body
  end
end
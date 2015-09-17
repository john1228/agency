namespace :showtime do
  desc '測試讀取某人到視頻秀'
  task :show do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.get '/showtime', mxid: 10004
    puts "dynamics:#{response.body}"
  end

  desc '测试视频秀更新'
  task :update do
    host = 'http://localhost'
    conn = Faraday.new(:url => host) do |req|
      req.request :multipart
      req.request :url_encoded
      req.adapter :net_http
    end
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.post '/showtime', title: '我的健身视频',
                         cover: Faraday::UploadIO.new("/root/桌面/images/024f78f0f736afc3e9876f57b019ebc4b745127c.jpg", 'image/jpeg'),
                         film: Faraday::UploadIO.new("/root/桌面/films/xinhu.mp4", 'application/octet-stream'),
                         content: '接口上传健身视频'
    puts "dynamics:#{response.body}"
  end
end
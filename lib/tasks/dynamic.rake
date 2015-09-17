namespace :dynamics do
  desc '动态列表'
  task :index do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.get '/dynamics', mxid: 10001
    puts response.body
  end

  desc '发布动态'
  task :create do
    host = 'http://localhost'
    conn = Faraday.new(:url => host) do |f|
      f.request :multipart
      f.request :url_encoded
      f.adapter :net_http
    end
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.post 'dynamics', content: '命令测试发布动态(带视频)',
                         cover: Faraday::UploadIO.new("/root/桌面/images/024f78f0f736afc3e9876f57b019ebc4b745127c.jpg", 'image/jpeg'),
                         film: Faraday::UploadIO.new("/root/桌面/films/xinhu.mp4", 'application/octet-stream')
    puts response.body
  end


  desc '发布动态'
  task :delete do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.delete 'dynamics/7'
    puts response.body
  end

  desc '发布动态'
  task :latest do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.get 'dynamics/latest', mxid: '10004'
    puts response.body
  end

end
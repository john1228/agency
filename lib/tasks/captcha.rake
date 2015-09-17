namespace :captcha do
  desc '用户注册'
  task :regist do
    #host = "http://www.e-mxing.com"
    host = "http://localhost"
    conn = Faraday.new(:url => host)
    response = conn.post "/captcha/regist", mobile: "18516691251"
    puts response.body
  end

  desc '用户登录 '
  task :change do
    host = "http://localhost"
    uri = URI.parse("#{host}/captcha/13916518973/change")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    response = http.request(request)
    puts response.body
  end

  desc '获取环信TOKEN'
  task :token do
    conn = Faraday.new(:url => "https://a1.easemob.com/jsnetwork/mxing/token")
    response = conn.post '/jsnetwork/mxing/token', {grant_type: "client_credentials", client_id: "YXA6HPZzIHIkEeSy6P9lvafoPA", client_secret: "YXA6GQOgkrCoDL61TY9IPzRcto4mJn4"}
    puts response.body
  end

  desc '验证验证码'
  task :check do
    #host = "http://www.e-mxing.com"
    host = "http://localhost"
    conn = Faraday.new(:url => host)
    conn.headers['token'] = '643fb4ded8fcd63e8114d2b577dac800'
    response = conn.post "/captcha/check", captcha: '824017'
    puts response.body
  end

end
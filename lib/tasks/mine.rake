namespace :mine do
  host = 'http://stage.e-mxing.com'
  token = '502e4a16930e414107ee22b6198c578f'

  desc '未完成课时'
  task :lesson_incomplete do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get 'mine/classes/incomplete'
    puts response.body
  end

  desc '未完成课时详情'
  task :lesson_incomplete_detail do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get 'mine/classes/incomplete/detail?id=162'
    puts response.body
  end

  desc '已完成课时'
  task :lesson_complete do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get 'mine/classes/complete'
    puts response.body
  end


  desc '已完成课时'
  task :wallet do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get 'mine/wallet'
    puts response.body
  end

  desc '订单'
  task :order do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get 'mine/orders', {status: 0}
    puts response.body
  end
end
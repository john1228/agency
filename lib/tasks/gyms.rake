namespace :gyms do
  host = 'http://localhost'
  token = 'a87ff679a2f3e71d9181a67b7542122c'

  desc '课程情况'
  task :courses do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = '182be0c5cdcd5072bb1864cdee4d3d6e'
    response = conn.get '/mine/lessons', list: 'all'
    puts response.body
  end

  desc '购买课程'
  task :courses_buy do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.post '/gyms/courses', contact_name: '小万万', contact_phone: '13585753578', pay_type: 1, item: '4:8'
    puts response.body
  end

  task :orders do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = '3c59dc048e8850243be8079a5c74d079'
    response = conn.get 'orders'
    puts response.body
  end

  task :lessons do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = token
    response = conn.get 'lessons'
    puts response.body
  end


  task :detail do
    conn = Faraday.new(:url => host)
    conn.headers[:token] = '33e75ff09dd601bbe69f351039152189'
    response = conn.get 'wallet/detail'
    puts response.body
  end


  #预约团操
end
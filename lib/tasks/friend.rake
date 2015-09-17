namespace :friends do

  desc '测试更新'
  task :index do
    host = "http://localhost:3000"
    conn = Faraday.new(:url => host)
    conn.headers['token'] = 'b487beb255dbbb9243d03c8b53c2ab5a'
    response = conn.get '/users/friends'
    json_obj = JSON.parse(response.body)
    puts json_obj
  end

  desc '测试删除'
  task :create do
    host = "http://localhost:3000"
    conn = Faraday.new(:url => host)
    response = conn.post 'friends'
    json_obj = JSON.parse(response.body)
    puts json_obj
  end

  desc '查找朋友 '
  task :search do
    host = "http://localhost:3000"
    conn = Faraday.new(:url => host)
    response = conn.get '/users/search', keyword: 1
    json_obj = JSON.parse(response.body)
    puts json_obj
  end
end
namespace :groups do

  desc '测试创建'
  task :create do
    host = 'http://192.168.0.111'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = '70efdf2ec9b086079795c442636b55fb'
    response = conn.post 'groups', name: '么型', intro: '介绍'
    puts response.body
  end
end
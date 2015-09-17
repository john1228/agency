namespace :comments do
  desc '动态列表'
  task :show do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.get 'comments', id: 1
    puts response.body
  end

  task :create do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.post 'comments', id: 1, content: '命令测试发表评论'
    puts response.body
  end
end
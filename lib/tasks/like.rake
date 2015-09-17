namespace :like do
  desc '动态列表'
  task :dynamic do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    conn.headers['token'] = 'a87ff679a2f3e71d9181a67b7542122c'
    response = conn.post 'like/dynamic', id: 1
    puts response.body
  end
end
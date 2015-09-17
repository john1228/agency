namespace :system do
  desc '反馈'
  task :feedback do
    host = 'http://192.168.0.111'
    conn = Faraday.new(:url => host)
    response = conn.post '/feedback', {content: "aaaaaaaaaaa", contact: "13916518973"}
    puts response.body
  end

  desc '发布轨迹'
  task :report do
    host = 'http://localhost'
    conn = Faraday.new(:url => host)
    response = conn.get '/report', id: 4
    puts response.body
  end

end
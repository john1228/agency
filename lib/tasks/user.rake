require 'base64'
namespace :users do

  desc '验证码完成后，完善用户信息'
  task :complete do
    conn = Faraday.new(url: 'http://localhost')
    conn.headers[:token] = '643fb4ded8fcd63e8114d2b577dac800'
    response = conn.post '/users/complete', password: '123456', name: '诸葛'
    puts response.body
  end


  desc '用户登录 '
  task :login do
    conn = Faraday.new(url: 'http://stage.e-mxing.com')
    response = conn.post '/users/login', {username: '15317717651', password: '123456'}
    puts response.body
  end

  desc '用户绑定'
  task :bind do
    faraday = Faraday.new(url: 'https://api.weibo.com')
    response = faraday.post '/2/statuses/update.json', {source: '3156824048', access_token: '2.005pTAICuIid8Dd57baf69850Cm2Qg', status: '测试一下', url: 'http://www.e-mxing.com/images/photos/2015/01/13/2342d01ece48e44206f332e9debe4879.jpeg'}
    puts "分享微博结果:#{response.body}"
  end


  desc '第三方登录'
  task :sns do
    host = "http://www.e-mxing.com"
    #host = "http://localhost:3000"
    conn = Faraday.new(:url => host)
    response = conn.post '/users/sns', {name: "万姜磊",
                                        sns_id: "FA0E505E35D82A0C2A962FA860B6AF4B",
                                        sns_name: "qq",
                                        icon: ""}

    puts response.body
  end

  desc 'friends'
  task :friends do
  end

  desc 'sync'
  task :sync => :environment do
    user = User.first
    host = 'http://zhaozhengweb.vicp.cc:8101'
    conn = Faraday.new(:url => host)
    response = conn.post '/WebService/MemebersWebService.asmx', {
                                                                  MemberID: user.id,
                                                                  MemberUserName: user.username,
                                                                  Name: user.profile.name,
                                                                  Sex: user.profile.gender.eql?('0') ? '男' : '女',
                                                                  ToKen: user.token,
                                                                  MobileNO: user.profile.mobile || ''
                                                              }
    puts response.body
  end

  desc '注册到环信'
  task :regist_to_easemob => :environment do
    User.all.map { |user|
      user.profile.regist_to_easemob
    }
  end

end
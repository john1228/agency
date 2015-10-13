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
    response = faraday.post '/2/statuses/update.json', {source: '3156824048', access_token: '2.005pTAICuIid8Dd57baf69850Cm2Qg', status: '测试一下', url: 'http://www.e-mxing.com/images/photos/2015/1/13/2342d01ece48e44206f332e9debe4879.jpeg'}
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


  desc '统计'
  task :shui => :environment do
    mxids = %w'30783 30784 30943 30952 31098 31119 31130 31227 31734 31861 31864 38535 38528
38532
38539
39895
39883
39885
39890
39893
33927
41386
41387
28554
28566
28548
28550
29737
28552
28549
28547
28551
28545
41388
41390
41391
51685'
    mxids.each { |mxid|
      user = User.find_by_mxid(mxid)
      puts "#{mxid}-#{user.dynamics.where(created_at: Date.new(2015, 9, 1)..Date.new(2015, 10, 1)).count}-#{DynamicImage.where(dynamic_id: user.dynamics.where(created_at: Date.new(2015, 9, 1)..Date.new(2015, 10, 1)).pluck(:id)).count}-#{user.comments.where(created_at: Date.new(2015, 9, 1)..Date.new(2015, 10, 1)).count}-#{Like.where(user_id: user.id, created_at: Date.new(2015, 9, 1)..Date.new(2015, 10, 1)).count}"
    }
  end

end
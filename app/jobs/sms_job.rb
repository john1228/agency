class SmsJob < ActiveJob::Base
  queue_as :default

  def perform(mobile, templateid, datas)
    conn = Faraday.new(url: 'https://sandboxapp.cloopen.com:8883')
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    account = 'aaf98f894b0b8616014b19c5e46709c3'
    account_token = '6212e011d5634ff896a9a179c313c217'
    appid = 'aaf98f894b0b8616014b19c7261f09cd'
    auth = Base64.strict_encode64(account + ':' + timestamp)

    conn.headers['Accept'] = 'application/json'
    conn.headers['Authorization'] = auth
    conn.headers['Content-Type'] = 'application/json;charset=utf-8'

    sig = Digest::MD5.hexdigest(account + account_token + timestamp)
    params = {to: "#{mobile}", appId: appid, templateId: templateid, datas: datas, data: ''}
    conn.post "/2013-12-26/Accounts/#{account}/SMS/TemplateSMS?sig=#{sig}", params.to_json
  end
end

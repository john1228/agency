class Terminal < ActiveRecord::Base
  def token
    Digest::MD5.hexdigest("#{id}|#{terminal}")
  end

  def service
    Service.find_by_mxid(mxid)
  end
end

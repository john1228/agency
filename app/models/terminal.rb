class Terminal < ActiveRecord::Base
  def token
    Digest::MD5.hexdigest("#{id}|#{terminal}")
  end
end

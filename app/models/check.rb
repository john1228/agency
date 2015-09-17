class Check < ActiveRecord::Base
  belongs_to :user
  after_create :polite
  validates_uniqueness_of :user_id, scope: :date
  private
  def polite
    #TODO 现在没有连续签到奖励
    user.wallet.update(bean: (user.wallet.bean + 5), action: WalletLog::ACTIONS['签到'])
  end
end

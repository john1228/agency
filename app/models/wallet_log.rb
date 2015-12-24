class WalletLog < ActiveRecord::Base
  belongs_to :wallet
  belongs_to :coach, foreign_key: :source
  enum action: {withdraw: 210, transfer: 211}


  def action_name
    ACTIONS.key(action)
  end

  def as_json
    {
        id: created_at.strftime('%Y%m%d' + '%04d' % id),
        action: action_name,
        balance: balance.to_f.round(2),
        created_at: created_at.to_i
    }
  end
end

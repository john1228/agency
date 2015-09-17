class WalletLog < ActiveRecord::Base
  ACTIONS = {'卖课收入' => 110, '上课收入' => 111, '签到' => 120, '兑换' => 130, '订单取消' => 131, '提现' => 210, '转账' => 211, '消费' => 212}

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

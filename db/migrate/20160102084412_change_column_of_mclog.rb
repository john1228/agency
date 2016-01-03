class ChangeColumnOfMclog < ActiveRecord::Migration
  def change
    # add_column :membership_card_logs, :action, :integer, default: 0
    # remove_column :membership_card_logs, :market_price
    # remove_column :membership_card_logs, :selling_price
    # add_column :membership_card_logs, :change_amount, :integer
    # add_column :membership_card_logs, :pay_amount, :integer
    # add_column :membership_card_logs, :operator, :string

    add_column :wallet_logs, :operator, :string
  end
end

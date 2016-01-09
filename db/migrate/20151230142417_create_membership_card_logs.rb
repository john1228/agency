class CreateMembershipCardLogs < ActiveRecord::Migration
  def change
    create_table :membership_card_logs do |t|
      t.integer :membership_card_id
      t.integer :action, default: 0
      t.integer :change_amount
      t.integer :pay_amount
      t.integer :pay_type
      t.string :entity_number
      t.integer :service_id
      t.integer :status
      t.string :seller
      t.string :remark
      t.string :operator
      t.string :option_code
      t.timestamps null: false
    end

    add_index :membership_card_logs, :membership_card_id
    add_index :membership_card_logs, :action
    add_index :membership_card_logs, :status
  end
end

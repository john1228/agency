class CreateMembershipCardLogs < ActiveRecord::Migration
  def change
    create_table :membership_card_logs do |t|
      t.integer :membership_card_id
      t.integer :market_price
      t.integer :selling_price
      t.integer :pay_type
      t.string :seller
      t.string :remark
      t.string :entity_number
      t.integer :service_id

      t.timestamps null: false
    end
  end
end

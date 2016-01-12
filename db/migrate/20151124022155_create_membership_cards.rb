class CreateMembershipCards < ActiveRecord::Migration
  def change
    create_table :membership_cards do |t|
      t.integer :client_id
      t.integer :service_id
      t.integer :order_id
      t.integer :member_id #关联会员ID
      t.integer :card_type #卡类型
      t.string :name
      t.integer :value #课程卡时,存储课程的类型
      t.integer :supply_value
      t.date :open
      t.integer :valid_days
      t.integer :delay_days
      t.integer :status, default: 0
      t.string :physical_card
      t.string :option_code, array: true, default: [] #课程卡时，存储消课码
      t.timestamps null: false
    end
    add_index :membership_cards, :service_id
    add_index :membership_cards, :member_id
    add_index :membership_cards, :card_type
  end
end

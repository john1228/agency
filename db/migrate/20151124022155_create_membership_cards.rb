class CreateMembershipCards < ActiveRecord::Migration
  def change
    create_table :membership_cards do |t|
      t.integer :client_id
      t.integer :service_id
      t.integer :coach_id
      t.integer :member_id #关联会员ID
      t.integer :card_type #卡类型
      t.string :name
      t.integer :value
      t.date :valid_start
      t.date :Valid_end
      t.timestamps null: false
    end
  end
end
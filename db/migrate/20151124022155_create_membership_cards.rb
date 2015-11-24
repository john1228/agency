class CreateMembershipCards < ActiveRecord::Migration
  def change
    create_table :membership_cards do |t|
      t.integer :user_id #关联会员ID
      t.integer :card_id #关联卡ID
      t.timestamps null: false
    end
  end
end

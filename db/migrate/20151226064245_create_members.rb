class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members, force: true do |t|
      t.integer :client_id
      t.integer :service_id
      t.integer :coach_id
      t.integer :user_id
      t.string :name
      t.string :avatar
      t.date :birthday
      t.integer :gender
      t.string :province
      t.string :city
      t.string :area
      t.string :address
      t.integer :member_type, default: 0
      t.integer :origin
      t.string :mobile
      t.string :remark
      t.timestamps null: false
    end
  end
end

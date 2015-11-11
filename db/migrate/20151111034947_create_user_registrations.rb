class CreateUserRegistrations < ActiveRecord::Migration
  def change
    create_table :user_registrations do |t|
      t.integer :reg_type
      t.string :avatar
      t.string :name
      t.integer :gender, default: 0
      t.integer :service_id
      t.integer :client_id
      t.string :mobile
      t.integer :source, default: 0
      t.datetime :birthday
      t.string :address
      t.string :remark

      t.timestamps null: false
    end
  end
end

class CreateTerminals < ActiveRecord::Migration
  def change
    create_table :terminals do |t|
      t.string :mxid
      t.string :terminal
      t.string :last_sign_in_ip
      t.timestamps null: false
    end
  end
end

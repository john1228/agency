class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.integer :card_id
      t.integer :value
      t.string :operator
      t.timestamps null: false
    end
  end
end

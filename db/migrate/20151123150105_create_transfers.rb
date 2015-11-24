class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :service_id
      t.integer :coach_id
      t.integer :amount
      t.timestamps null: false
    end
  end
end

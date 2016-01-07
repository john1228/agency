class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :card_type_id
      t.string :image, array: true
      t.string :description
      t.string :special
      t.timestamps null: false
    end
  end
end

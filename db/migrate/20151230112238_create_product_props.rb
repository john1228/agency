class CreateProductProps < ActiveRecord::Migration
  def change
    create_table :product_props do |t|
      t.integer :product_id
      t.integer :during
      t.integer :proposal
      t.string :style
    end
  end
end

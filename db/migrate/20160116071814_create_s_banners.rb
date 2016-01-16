class CreateSBanners < ActiveRecord::Migration
  def change
    create_table :s_banners do |t|
      t.integer :service_id
      t.string :title
      t.string :pos_1, array: true
      t.string :pos_2, array: true
      t.string :pos_3, array: true
      t.timestamps null: false
    end
  end
end

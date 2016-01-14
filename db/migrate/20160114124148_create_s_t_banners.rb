class CreateSTBanners < ActiveRecord::Migration
  def change
    create_table :s_t_banners do |t|
      t.integer :service_id
      t.string :pos_first, array: true
      t.string :pos_second, array: true
      t.string :pos_third, array: true
      t.timestamps null: false
    end
  end
end

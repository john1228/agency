class CreateCoachDiscountDefaults < ActiveRecord::Migration
  def change
    create_table :coach_discount_defaults do |t|
      t.integer :coach_id
      t.integer :discount
      t.integer :giveaway_cash
      t.integer :giveaway_count
      t.integer :giveaway_day
    end
  end
end

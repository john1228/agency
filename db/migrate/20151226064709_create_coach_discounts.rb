class CreateCoachDiscounts < ActiveRecord::Migration
  def change
    create_table :coach_discounts do |t|
      t.integer :coach_id
      t.string :card_id
      t.integer :discount
      t.integer :giveaway
    end
  end
end

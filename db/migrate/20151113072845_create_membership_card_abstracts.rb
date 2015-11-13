class CreateMembershipCardAbstracts < ActiveRecord::Migration
  def change
    create_table :membership_card_abstracts do |t|
      t.string :name
      t.integer :service_id
      t.integer :client_id
      t.integer :card_type
      t.float :price
      t.integer :count
      t.integer :days
      t.boolean :has_valid_extend_information
      t.integer :valid_days
      t.integer :latest_delay_days

      t.timestamps null: false
    end
  end
end

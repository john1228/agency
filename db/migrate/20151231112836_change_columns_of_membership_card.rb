class ChangeColumnsOfMembershipCard < ActiveRecord::Migration
  def change
    remove_column :membership_cards, :valid_start
    remove_column :membership_cards, :valid_end
    add_column :membership_cards, :open, :date
    add_column :membership_cards, :valid_days, :integer
  end
end

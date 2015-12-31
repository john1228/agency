class ChangeColumnsOfMembershipCard < ActiveRecord::Migration
  def change
    rename_column :membership_card_type, :last_delay_days, :delay_days
    rename_column :membership_card_type, :count, :value
  end
end

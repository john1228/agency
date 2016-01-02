class ChangeColumnsOfMembershipCard < ActiveRecord::Migration
  def change
    rename_column :membership_card_types, :latest_delay_days, :delay_days
    rename_column :membership_card_types, :count, :value
  end
end

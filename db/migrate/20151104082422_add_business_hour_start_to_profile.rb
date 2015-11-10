class AddBusinessHourStartToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :business_hour_start, :string
    add_column :profiles, :business_hour_end, :string
  end
end

class AddProvinceToUserRegistration < ActiveRecord::Migration
  def change
    add_column :user_registrations, :province, :string
    add_column :user_registrations, :city, :string
  end
end

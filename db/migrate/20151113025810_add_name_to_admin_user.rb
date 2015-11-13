class AddNameToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :name, :string
    add_column :admin_users, :birthday, :string
    add_column :admin_users, :gender, :integer, default:0
    add_column :admin_users, :mobile, :string
    add_column :admin_users, :remark, :string
    add_column :admin_users, :avatar, :string
  end
end

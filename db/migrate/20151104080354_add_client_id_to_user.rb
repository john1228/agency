class AddClientIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :client_id, :integer
    add_column :admin_users, :client_id, :integer
  end
end

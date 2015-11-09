class AddCommentsCountToDynamic < ActiveRecord::Migration
  def change
    add_column :dynamics, :comments_count, :integer, default: 0
  end
end

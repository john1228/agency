class CreateMemberLogs < ActiveRecord::Migration
  def change
    create_table :member_logs do |t|
      t.integer :member_id
      t.integer :action
      t.string :remark
      t.string :attachment, array: true
      t.string :operator
      t.timestamps null: false
    end
  end
end

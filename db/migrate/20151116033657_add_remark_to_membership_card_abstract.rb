class AddRemarkToMembershipCardAbstract < ActiveRecord::Migration
  def change
    add_column :membership_card_abstracts, :remark, :string
  end
end

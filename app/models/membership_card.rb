class MembershipCard < ActiveRecord::Base
  belongs_to :user
  belongs_to :card_type, class: MembershipCardType, foreign_key: :card_id
end

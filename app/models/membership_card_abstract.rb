class MembershipCardAbstract < ActiveRecord::Base
  enum card_type: [:deposit,:by_count,:by_time]

  belongs_to :service
end

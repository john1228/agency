class MemberLog < ActiveRecord::Base
  enum action: [:creation, :binding, :activation, :charging, :blocking, :transfer]
  belongs_to :member
end

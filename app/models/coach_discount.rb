class CoachDiscount < ActiveRecord::Base
  belongs_to :coach
  belongs_to :card, class: Sku
end

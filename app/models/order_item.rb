class OrderItem < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :order
end

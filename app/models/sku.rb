class Sku < ActiveRecord::Base
  self.primary_key = :sku
  before_create :injection
  enum status: [:offline, :online]
  enum course_type: [:stored, :measured, :clocked, :course]

  belongs_to :course, class: Product
  belongs_to :service

  protected
  def injection
    self.orders_count = rand(100)
  end
end

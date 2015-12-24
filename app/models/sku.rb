class Sku < ActiveRecord::Base
  self.primary_key = :sku
  before_create :injection
  enum sku_type: [:course, :card]
  enum status: [:offline, :online]


  belongs_to :product
  belongs_to :service

  protected
  def injection
    self.orders_count = rand(100) unless card?
  end
end

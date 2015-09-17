class OrderItem < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :order

  def as_json
    sku_info = Sku.find_by(sku: sku)
    {
        sku: sku,
        name: name,
        cover: cover,
        type: type,
        price: price,
        during: during,
        amount: amount,
        guarantee: sku_info.course.guarantee
    }
  end
end

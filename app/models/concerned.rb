class Concerned < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :sku
  after_create :update_count

  def as_json
    sku_info = Sku.find_by(sku: sku)
    sku_info.as_json.merge(
        status: sku_info.status,
        address: {
            name: sku_info.address,
            coordinate: {
                lng: sku_info.coordinate.x,
                lat: sku_info.coordinate.y
            }
        }
    )
  end

  private
  def update_count
    Sku.where('sku LIKE ?', sku[0, sku.rindex('-')] + '%').update_all('concerns_count = concerns_count + 1')
  end
end

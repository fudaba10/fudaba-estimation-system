class EstimateDetail < ApplicationRecord
  validates :product_name, presence: true
  validates :vendor_id, presence: true
  validates :quantity, numericality: {greater_than: 0}
  validates :unit_price, numericality: {greater_than_or_equal_to: 0}


  belongs_to :estimate_header
  belongs_to :vendor
end

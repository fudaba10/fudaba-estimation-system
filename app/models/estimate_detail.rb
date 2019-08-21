class EstimateDetail < ApplicationRecord
  validates :product_name, presence: true
  validates :vendor_id, presence: true

  belongs_to :estimate_header
  belongs_to :vendor
end

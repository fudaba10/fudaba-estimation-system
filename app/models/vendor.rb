class Vendor < ApplicationRecord
  validates :vendor_name, presence: true
  validates :vendor_name_kana, presence: true

  has_many :estimate_details

end

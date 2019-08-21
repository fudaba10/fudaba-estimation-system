class Customer < ApplicationRecord
  validates :customer_name, presence: true
  validates :customer_name_kana, presence: true
  validates :customer_initial, presence: true

  has_many :estimate_headers
end

class EstimateHeader < ApplicationRecord
  validates :customer, presence: true
  validates :customer_person, presence: true

  has_many :estimate_details
  accepts_nested_attributes_for :estimate_details

  belongs_to :customer
  belongs_to :employee

end

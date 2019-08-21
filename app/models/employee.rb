class Employee < ApplicationRecord
  has_secure_password

  validates :employee_name, presence: true
  validates :employee_name_kana, presence: true
  validates :login_id, presence: true, uniqueness: true

  has_many :estimate_headers
end

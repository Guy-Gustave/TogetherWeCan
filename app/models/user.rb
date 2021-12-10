class User < ApplicationRecord
  has_secure_password

  validates :first_name, presence: true, length: {minimum: 3}
  validates :last_name, presence: true, length: {minimum: 3}
  validates :telephone_number, presence: true, length: {minimum: 6}
  validates :account_number, presence: true
  validates :email, presence: true, uniqueness: true
  validates :bank_name, presence: true
  validates :country, presence: true
end

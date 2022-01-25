class Gift < ApplicationRecord
  belongs_to :user
  belongs_to :capital
  belongs_to :purchase
  has_one :admin_account

  validates :amount, presence: true
  validates :capital, presence: true
  validates :user, presence: true
end

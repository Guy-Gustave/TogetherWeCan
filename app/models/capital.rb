class Capital < ApplicationRecord
  belongs_to :user
  has_many :gifts, dependent: :destroy

  validates :amount, presence: true
  validates :user, presence: true
  validates :capital_name, presence: true

end

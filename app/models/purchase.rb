class Purchase < ApplicationRecord
  belongs_to :user
  has_many :capitals, dependent: :destroy
  has_many :gifts, dependent: :destroy

  validates :purchase_number, presence: true
end

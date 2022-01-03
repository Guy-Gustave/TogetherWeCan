class AdminAccount < ApplicationRecord
  belongs_to :gift

  validates :gift, presence: true
  validates :amount, presence: true

end

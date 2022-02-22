class Transaction < ApplicationRecord
  belongs_to :capital
  belongs_to :gift, optional: true

  TRANSACTION_TYPES = ["payment", "deposit"]

  validates :capital, presence: true
  validates :amount, presence: true, numericality: true
  validates :transaction_type, presence: true, inclusion: { in: TRANSACTION_TYPES }
  validates :transaction_number, presence: true, uniqueness: true
  validates :week_number, presence: true

  before_validation :load_defaults

  def load_defaults
    if self.new_record?
      self.transaction_number = SecureRandom.uuid
    end
  end
end

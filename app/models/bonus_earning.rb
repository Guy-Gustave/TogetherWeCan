class BonusEarning < ApplicationRecord
  belongs_to :user

  BONUS_TYPES = ["share_bonus", "invitation_bonus"]

  validates :bonus_type, presence: true, inclusion: {in: BONUS_TYPES}
end

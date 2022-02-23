class User < ApplicationRecord
  has_secure_password
  has_many :capitals, dependent: :destroy
  has_many :gifts, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :savings
  has_many :bonus_earnings

  has_many :invited_users, foreign_key: :inviter_id, class_name: 'Invitation', dependent: :destroy
  has_many :invitees, through: :invited_users, dependent: :destroy

  has_one :inviter_user, foreign_key: :invitee_id, class_name: 'Invitation', dependent: :destroy
  has_one :inviter, through: :inviter_user, dependent: :destroy

  validates :first_name, presence: true, length: { minimum: 3 }
  validates :last_name, presence: true, length: { minimum: 3 }
  validates :telephone_number, presence: true, length: { minimum: 6 }
  validates :account_number, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create },
                    uniqueness: { case_sensitive: false }, presence: true
  validates :bank_name, presence: true
  validates :country, presence: true
end

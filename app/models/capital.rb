class Capital < ApplicationRecord
  include ApplicationHelper

  belongs_to :user
  belongs_to :purchase
  has_many :gifts, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :savings

  CAPITAL_STATUS = ['original', 'recreated']

  validates :amount, presence: true
  validates :user, presence: true
  validates :capital_name, presence: true
  validates :capital_status, presence: true, inclusion: { in: CAPITAL_STATUS }

  before_validation :load_defaults

  def load_defaults
    if self.new_record?
      self.period = 0
    end
  end

  def self.set_new_capital_name(purchase)
    last_capital = purchase.week_number >= PHASE_2_WEEK ? Capital.where(user_id: purchase.user_id, purchase_id: purchase.id, phase_status: 'phase_2').last : Capital.where(user_id: purchase.user_id, purchase_id: purchase.id ).last
    new_capital_name = ''
    if last_capital
      new_capital_name = last_capital.capital_name
      new_capital_name.delete_prefix!("capital-")
      new_capital_name = "capital-" + (new_capital_name.to_i + 1).to_s;
    else
      new_capital_name = "capital-1"
    end

    new_capital_name
  end

end

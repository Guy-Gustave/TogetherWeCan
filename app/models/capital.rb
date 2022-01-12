class Capital < ApplicationRecord
  belongs_to :user
  has_many :gifts, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :amount, presence: true
  validates :user, presence: true
  validates :capital_name, presence: true

  def self.set_new_capital_name(current_user)
    last_capital = Capital.where(user_id: current_user.id).last
    new_capital_name = ""
    if last_capital
      new_capital_name = last_capital.capital_name
      new_capital_name.delete_prefix!("capital")
      new_capital_name = "capital" + (new_capital_name.to_i + 1).to_s;
    else
      new_capital_name = "capital1"
    end

    new_capital_name
  end

end

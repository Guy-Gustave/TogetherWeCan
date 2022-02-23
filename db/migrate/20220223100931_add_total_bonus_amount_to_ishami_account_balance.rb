class AddTotalBonusAmountToIshamiAccountBalance < ActiveRecord::Migration[6.0]
  def change
    add_column :ishami_account_balances, :total_bonus_amount, :decimal, default: 0.0
  end
end

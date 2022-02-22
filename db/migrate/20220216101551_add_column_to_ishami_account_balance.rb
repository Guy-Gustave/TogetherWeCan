class AddColumnToIshamiAccountBalance < ActiveRecord::Migration[6.0]
  def change
    add_column :ishami_account_balances, :total_gift_amount, :decimal, default: 0.0
  end
end

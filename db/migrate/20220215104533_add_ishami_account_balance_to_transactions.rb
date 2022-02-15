class AddIshamiAccountBalanceToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_reference :transactions, :ishami_account_balance, null: false, foreign_key: true
  end
end

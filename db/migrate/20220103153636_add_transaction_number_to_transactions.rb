class AddTransactionNumberToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :transaction_number, :string
  end
end

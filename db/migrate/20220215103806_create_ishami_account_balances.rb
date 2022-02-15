class CreateIshamiAccountBalances < ActiveRecord::Migration[6.0]
  def change
    create_table :ishami_account_balances do |t|
      t.decimal :saving_amount
      t.decimal :total_amount
      t.references :ishami_bank_account, null: false, foreign_key: true

      t.timestamps
    end
  end
end

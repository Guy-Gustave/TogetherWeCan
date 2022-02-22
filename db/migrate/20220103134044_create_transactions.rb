class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :capital, null: false, foreign_key: true
      t.decimal :amount
      t.string :transaction_type
      t.integer :week_number

      t.timestamps
    end
  end
end

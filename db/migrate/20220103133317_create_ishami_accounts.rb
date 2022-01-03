class CreateIshamiAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :ishami_accounts do |t|
      t.integer :week_number
      t.decimal :total_amount

      t.timestamps
    end
  end
end

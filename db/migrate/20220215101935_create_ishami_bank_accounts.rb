class CreateIshamiBankAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :ishami_bank_accounts do |t|
      t.string :account_number
      t.string :bank_name

      t.timestamps
    end
  end
end

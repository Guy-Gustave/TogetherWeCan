class CreateAdminAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_accounts do |t|
      t.references :ishami_bank_account, null: false, foreign_key: true
      t.decimal :total_admin_amount

      t.timestamps
    end
  end
end

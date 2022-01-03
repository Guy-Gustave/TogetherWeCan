class CreateAdminAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_accounts do |t|
      t.references :gift, null: false, foreign_key: true
      t.integer :week_number
      t.decimal :amount

      t.timestamps
    end
  end
end

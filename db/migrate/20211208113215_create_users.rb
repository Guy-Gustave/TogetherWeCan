class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :telephone_number
      t.string :account_number
      t.string :email
      t.string :password_digest
      t.string :bank_name
      t.string :country
      t.string :identification_number, default: nil

      t.timestamps
    end
  end
end

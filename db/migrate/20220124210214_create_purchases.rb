class CreatePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :purchases do |t|
      t.string :purchase_number
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

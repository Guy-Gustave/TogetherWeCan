class CreateSavings < ActiveRecord::Migration[6.0]
  def change
    create_table :savings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :capital, null: false, foreign_key: true
      t.decimal :savings_amount

      t.timestamps
    end
  end
end

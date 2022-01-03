class CreateCapitals < ActiveRecord::Migration[6.0]
  def change
    create_table :capitals do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount
      t.string :capital_name
      t.decimal :savings

      t.timestamps
    end
  end
end

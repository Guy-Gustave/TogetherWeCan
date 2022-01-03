class CreateGifts < ActiveRecord::Migration[6.0]
  def change
    create_table :gifts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :capital, null: false, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
  end
end

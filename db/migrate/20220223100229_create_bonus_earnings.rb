class CreateBonusEarnings < ActiveRecord::Migration[6.0]
  def change
    create_table :bonus_earnings do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :bonus_amount, default: 0.0
      t.string :bonus_type

      t.timestamps
    end
  end
end

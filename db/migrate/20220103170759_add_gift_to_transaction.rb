class AddGiftToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_reference :transactions, :gift, null: true, foreign_key: true
  end
end

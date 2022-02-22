class AddColumnsToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :savings_amount, :decimal
    add_column :purchases, :next_capitals, :integer
  end
end

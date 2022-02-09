class AddColumnToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :week_number, :integer, default: 0
  end
end

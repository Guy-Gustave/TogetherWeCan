class AddColumnsToCapital < ActiveRecord::Migration[6.0]
  def change
    add_column :capitals, :gift_counter, :integer, default: 0
    add_column :capitals, :recreation_date, :string
    add_column :capitals, :capital_status, :string, default: "original"
  end
end

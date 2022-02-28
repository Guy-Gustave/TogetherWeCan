class AddColumnsToCapital < ActiveRecord::Migration[6.0]
  def change
    add_column :capitals, :gift_counter, :integer, default: 0
    add_column :capitals, :recreation_date, :string
    add_column :capitals, :capital_status, :string, default: "original"
    add_column :capitals, :phase_status, :string, default: 'phase_1'
    add_column :capitals, :new_creation_date, :string
  end
end

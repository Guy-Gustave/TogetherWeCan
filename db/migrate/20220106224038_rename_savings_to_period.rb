class RenameSavingsToPeriod < ActiveRecord::Migration[6.0]
  def change
    rename_column :capitals, :savings, :period
    change_column :capitals, :period, :integer
  end
end

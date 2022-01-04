class ChangeColumnNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :transactions, :gift_id, null: true, foreign_key: true
  end
end

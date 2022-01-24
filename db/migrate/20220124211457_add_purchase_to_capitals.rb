class AddPurchaseToCapitals < ActiveRecord::Migration[6.0]
  def change
    add_reference :capitals, :purchase, null: false, foreign_key: true
  end
end

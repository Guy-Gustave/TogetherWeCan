class AddPurchaseGiftAmountToPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :purchases, :purchase_gift_amount, :decimal, default: 0.0
  end
end

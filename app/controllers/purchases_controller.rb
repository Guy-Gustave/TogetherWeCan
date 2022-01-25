class PurchasesController < ApplicationController

  def create(current_user)
    last_purchase = Purchase.where(user_id: current_user.id).last
    purchase_no = 1

    if last_purchase
      p_number = last_purchase.purchase_number.delete_prefix('purchase-').to_i
      purchase_no = p_number+1
    end

    new_purchase = Purchase.new(user_id: current_user.id, purchase_number: "purchase-#{purchase_no}")
    new_purchase.save
  end
end
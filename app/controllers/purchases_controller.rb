class PurchasesController < ApplicationController
  include CurrentUserConcern
  include CapitalsHelper

  before_action :confirm_current_user, only: [:index]

  def index
    @purchases = @current_user.purchases.includes(:capitals)
    total_capital_1_amount = 0
    capitals = []
    @purchases.each { |purchase| capitals += purchase.capitals }
    # Use constant "CAPITAL_AMOUNT" below to maintain the capital amount returned to the front end even when the purchase week number is beyond week 33 where the actual capital amount changes. 
    capitals.each { |cap| total_capital_1_amount += CAPITAL_AMOUNT if cap.capital_name == 'capital-1' }

    render json: {
      purchases: @purchases,
      user_capitals: capitals,
      shares_total_amount: total_capital_1_amount,
      original_capital_amount: CAPITAL_AMOUNT
    }
  end

  def create(current_user)
    last_purchase = Purchase.where(user_id: current_user.id).last
    purchase_no = 1

    if last_purchase
      p_number = last_purchase.purchase_number.delete_prefix('purchase-').to_i
      purchase_no = p_number+1
    end

    new_purchase = Purchase.new(user_id: current_user.id, purchase_number: "purchase-#{purchase_no}")
    new_purchase.save

    new_purchase
  end
end
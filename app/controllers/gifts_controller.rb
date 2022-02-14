class GiftsController < ApplicationController

  include GiftsHelper

  def index
    gifts = Gift.where(capital_id: 2)
    render json: {
      gifts: gifts
    }
  end

  def create(current_user, capital)
    @gift = Gift.new(user_id: current_user.id, capital_id: capital.id, amount: get_gift_amount(capital), purchase_id: capital.purchase_id)

    @gift.save
    @gift
  end
end
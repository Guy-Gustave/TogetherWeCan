class GiftsController < ApplicationController

  include GiftsHelper

  def create(current_user, capital)
    @gift = Gift.new(user_id: current_user.id, capital_id: capital.id, amount: GIFT_AMOUNT)

    @gift.save
  end
end
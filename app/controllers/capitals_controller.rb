class CapitalsController < ApplicationController

  include CurrentUserConcern
  include CapitalsHelper

  before_action :confirm_current_user, only: [:index, :create]

  def index
    capitals = Capital.all

    render json: {
      capitals: capitals
    }
  end
  

  def create(purchase)
    # current_user = User.where(id: purchase.user_id)
    new_capital_name = Capital.set_new_capital_name(purchase)
    
    @capital = Capital.new(user_id: current_user.id, amount: CAPITAL_AMOUNT, capital_name: new_capital_name, purchase_id: purchase.id);

    @capital.save

    @capital
    # CapitalsHelper::CAPITAL_AMOUNT
    # CAPITAL_AMOUNT
  end

  
  private

  def confirm_current_user
    if !@current_user
      render json: {
        error: "Bad Request"
      }, status: 400
    end
  end

end
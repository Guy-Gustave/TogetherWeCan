class CapitalsController < ApplicationController

  include CurrentUserConcern

  before_action :confirm_current_user, only: [:index, :create]

  def index
    capitals = Capital.all

    render json: {
      capitals: capitals
    }
  end
  

  def create(current_user)

    new_capital_name = Capital.set_new_capital_name(current_user)
    
    @capital = Capital.new(user_id: current_user.id, amount: CAPITAL_AMOUNT, capital_name: new_capital_name, savings: 0);

    @capital.save

    @capital
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
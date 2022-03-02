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
    
    @capital = Capital.new(user_id: purchase.user_id, amount: CAPITAL_AMOUNT, capital_name: new_capital_name, purchase_id: purchase.id);

    @capital.save

    @capital
  end

  def update_capital_phase(purchase)
    new_capital_name = Capital.set_new_capital_name(purchase)
    capital = Capital.where(user_id: purchase.user_id, purchase_id: purchase.id, capital_name: new_capital_name).first
    capital.update(phase_status: 'phase_2', capital_status: 'original')
    capital.update(new_creation_date: capital.updated_at.to_s)

    capital
  end
end

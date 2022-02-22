class SavingsController < ApplicationController
  include CurrentUserConcern
  
  def index
    savings = @current_user.savings
    render json: {
      savings: savings
    }, status: 200
  end
end
class CapitalsController < ApplicationController

  include CurrentUserConcern

  before_action :confirm_current_user, only: [:index]

  def index
    capitals = User.all

    render json: {
      capitals: capitals
    }
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
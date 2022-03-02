module CurrentUserConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user
  end

  def set_current_user
    @current_user = User.where(id: session[:user_id]).first if session[:user_id]
  end

  def confirm_current_user
    if !@current_user
      render json: {
        error: "Bad Request"
      }, status: 400
    end
  end
end

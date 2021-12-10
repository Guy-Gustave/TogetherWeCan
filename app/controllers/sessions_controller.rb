class SessionsController < ApplicationController

  def create
    user = User.find_by(email: session_params["email"]).try(:authenticate, session_params["password"])

    if user
      session[:user_id] = user.id
      render json: {
        status: :created,
        logged_in: true,
        user: user
      }, status: :created
    else
      render json: status: 403
    end

  end


  private

  def session_params
    params.require(:user).permit(:email, :password)
  end
end
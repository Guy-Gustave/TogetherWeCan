class SessionsController < ApplicationController

  include CurrentUserConcern

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
      render json: {
        status: 403,
        error: "Email or Password is incorrect!"
      }
    end

  end

  def logged_in
    if @current_user
      render json: {
        logged_in: true,
        user: @current_user
      }
    else
      render json: {
        logged_in: false,
      }
    end
  end

  def logout 
    reset_session
    render json: {
      logged_in: false,
      logged_out: true,
      status: 200
    }, status: 200
  end

  private

  def session_params
    params.require(:user).permit(:email, :password)
  end
end
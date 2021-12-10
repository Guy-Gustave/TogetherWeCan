class RegistrationsController < ApplicationController

  def create
    user = User.create!(registration_params)

    if user
      session[:user_id] = user.id
      render json: {
        status: :created,
        logged_in: true,
        user: user
      }, status: :created

    else
      render json: {status: 422}
    end
  end

  private

  def registration_params
    params.require(:user).permit(:first_name, :last_name,:telephone_number, :account_number, :email, :password, :password_confirmation, :bank_name, :country, :identification_number)
  end
end

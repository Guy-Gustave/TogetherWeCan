class RegistrationsController < ApplicationController

  def create
    if (params['user']['contribution'] && params['user']['membership_fee'] && params['user']['rules'])
      user = User.new(
        first_name: params['user']['first_name'],
        last_name: params['user']['last_name'],
        telephone_number: params['user']['telephone_number'],
        account_number: params['user']['account_number'],
        bank_name: params['user']['bank_name'],
        country: params['user']['country'],
        email: params['user']['email'],
        password: params['user']['password'],
        password_confirmation: params['user']['password_confirmation'],
      )
  
      if user.save
        session[:user_id] = user.id
        render json: {
          status: :created,
          logged_in: true,
          user: user
        }, status: :created
  
      else
        render json: {
          status: 422,
          errors: user.errors
        }, status:422
      end
    else
      render json: {
        errors: ["You must agree the terms and conditions, if not go away!"]
      }, status: 422
    end
    
  end

  private

  # def registration_params
  #   params.require(:user).permit(:first_name, :last_name,:telephone_number, :account_number, :email, :password, :password_confirmation, :bank_name, :country, :identification_number, :contribution, :membership_fee, :rules)
  # end

  # def confirmation_params 
  #   params.require(:user).permit(:)
  # end
end

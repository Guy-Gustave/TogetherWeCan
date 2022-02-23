class RegistrationsController < ApplicationController
  def create
    if params['user']['contribution'] && params['user']['membership_fee'] && params['user']['rules']

      user = User.new(registration_params)

      if user.save
        session[:user_id] = user.id
        create_invitation(params['user']['inviter_email'], user) if params['user']['inviter_email'] != ""
        render json: {
          status: :created,
          logged_in: true,
          user: user
        }, status: :created

      else
        render json: {
          status: 422,
          errors: user.errors
        }, status: 422
      end
    else
      render json: {
        errors: { 'Confirmation error:': ['You must agree to all the terms and conditions, if not go away!'] }
      }, status: 422
    end
  end

  private

  def registration_params
    params.require(:user).permit(:first_name, :last_name, :telephone_number, :account_number, :email, :password,
                                 :password_confirmation, :bank_name, :country, :identification_number)
  end

  # def confirmation_params
  #   params.require(:user).permit(:)
  # end
  
  def create_invitation(email, created_user)
    inviter = User.find_by(email: email)
    invitation_entry = Invitation.new(inviter_id: inviter.id, invitee_id: created_user.id)
    invitation_entry.save
  end
end

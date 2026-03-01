class GuestController < ApplicationController
  def signup_prompt
  end

  def to_signup
    sign_out(current_user)
    redirect_to new_user_registration_path
  end

  def to_login
    sign_out(current_user)
    redirect_to new_user_session_path
  end
end

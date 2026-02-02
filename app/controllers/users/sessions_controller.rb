# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  def guest
    user = User.find_or_create_by!(email: 'guest@example.com') do |u|
      u.password = SecureRandom.urlsafe_base64
    end

    sign_in user
    redirect_to home_path, notice: 'ゲストとしてログインしました'
  end
end

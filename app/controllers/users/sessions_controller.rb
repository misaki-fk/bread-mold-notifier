class Users::SessionsController < Devise::SessionsController
  # ログイン前に何か処理をしたい場合はここに書く
  # 例:
  # before_action :configure_sign_in_params, only: [:create]
  def create
    cookies.delete(:guest_user_id)
    cookies.signed[:guest_user_id] = nil
    super
  end
  # GET /users/sign_in
  # def new
  #   super
  # end

  # POST /users/sign_in
  # def create
  #   super
  # end

  # DELETE /users/sign_out
  # def destroy
  #   super
  # end

  # private
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
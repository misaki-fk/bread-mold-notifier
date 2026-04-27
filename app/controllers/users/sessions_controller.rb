class Users::SessionsController < Devise::SessionsController
  # ログイン前に何か処理をしたい場合はここに書く
  # 例:
  # before_action :configure_sign_in_params, only: [:create]
  def create
    cookies.delete(:guest_user_id)
    cookies.signed[:guest_user_id] = nil
    
    super do |resource|
      resource.remember_me = true

      if resource.persisted? && resource.line_user_id.blank? && !Notification.exists?(user: resource, notification_type: "system")
        Notification.create!(
          user: resource,
          notification_type: "system",
          message: Notification.line_promo_message
          notified_at: Time.zone.now
        )
      end
    end
  end
  # GET /users/sign_in
  # def new
  #   super
  def destroy
    if current_user&.guest?
      super do
        flash.delete(:notice)
      end
    else
      super
    end
  end

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
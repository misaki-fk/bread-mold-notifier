class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    auth = request.env["omniauth.auth"]

    if auth.blank?
      redirect_to root_path, alert: "LINEログインに失敗しました"
      return
    end

    if user_signed_in?
      # 連携
      current_user.update!(
        line_user_id: auth.uid,
        line_notify_enabled: true
      )

      redirect_to notification_settings_path, notice: "LINE連携しました！通知をONにしました"
      return

    else
      # LINEログイン
      @user = User.find_or_create_by!(provider: auth.provider, uid: auth.uid) do |u|
        u.name ||= auth.info.name
        u.email = auth.info.email || "#{auth.uid}@example.com"
        u.password = Devise.friendly_token[0, 20]
      end

      @user.update!(line_user_id: auth.uid)

      if @user.persisted?
        sign_in_and_redirect @user, notice: "LINEでログインしました！"
      else
        redirect_to root_path, alert: "LINEログインに失敗しました"
      end
    end

  rescue StandardError => e
    Rails.logger.error("LINEログインエラー: #{e.message}")
    redirect_to root_path, alert: "LINEログインに失敗しました"
  end
end
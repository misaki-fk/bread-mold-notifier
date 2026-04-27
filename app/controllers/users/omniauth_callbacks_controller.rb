class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    auth = request.env["omniauth.auth"]

    if auth.blank?
      redirect_to root_path, alert: "LINEログインに失敗しました"
      return
    end

    if user_signed_in?
      # 連携済み
      existing_user = User.find_by(line_user_id: auth.uid)
      
      if existing_user && existing_user != current_user
        redirect_to notification_settings_path,
        alert: "このLINEアカウントは既に他のアカウントと連携されています。LINEログインをお試しください。"
        return
      end

      # 連携
      current_user.update!(
        line_user_id: auth.uid,
        line_notify_enabled: true
      )

      redirect_to notification_settings_path, notice: "LINE連携しました！通知をONにしました"
      return

    else
      # 連携済みユーザーを探す
      user = User.find_by(line_user_id: auth.uid)
      # provider + uid で探す
      user ||= User.find_by(provider: auth.provider, uid: auth.uid)
      # LINEログイン
      if user
        # 既存ユーザーでログイン
        sign_in_and_redirect user, notice: "LINEでログインしました！"
      else
        # 新規登録
        user = User.create!(
          provider: auth.provider,
          uid: auth.uid,
          name: auth.info.name,
          email: auth.info.email || "#{auth.uid}@example.com",
          password: Devise.friendly_token[0, 20],
          line_user_id: auth.uid
        )

        sign_in_and_redirect user, notice: "LINEで新規登録しました！"
      end
    end

  rescue StandardError => e
    Rails.logger.error("LINEログインエラー: #{e.message}")
    redirect_to root_path, alert: "LINEログインに失敗しました"
  end
end
end
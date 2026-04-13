class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    auth = request.env["omniauth.auth"]

    @user = User.find_or_create_by!(provider: auth.provider, uid: auth.uid) do |u|
      u.name ||= auth.info.name
      u.email = auth.info.email || "#{auth.uid}@example.com"
      u.password = Devise.friendly_token[0, 20]
    end

    if @user.persisted?
      sign_in_and_redirect @user, notice: "LINEでログインしました！"
    else
      redirect_to root_path, alert: "ログインに失敗しました"
    end
  end
end
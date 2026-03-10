class GuestSessionsController < Devise::SessionsController
  def create
    # 既にログインしている場合はログアウト
    sign_out_all_scopes if user_signed_in?
  
    user = nil
    guest_user_id = cookies.signed[:guest_user_id]
    
    # ブラウザから送られた guest_user_id を取得
    if guest_user_id.present?
      user = User.find_by(id: guest_user_id, guest: true)
    end

    # 見つからなければ新規作成
    unless user
      user = User.create_guest
      cookies.signed[:guest_user_id] = {
        value: user.id,
        expires: 1.month.from_now # 有効期限は任意
      }
    end

    sign_in(user)
    redirect_to home_path, notice: "パン管理をはじめましょう！"
  end
end

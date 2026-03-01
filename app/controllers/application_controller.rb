class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    home_path
  end

  def after_sign_up_path_for(resource)
    home_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  private

  def reject_guest_user
    if user_signed_in? && current_user.guest?
      redirect_to guest_signup_prompt_path,
                  alert: "この機能は会員登録が必要です"
    end
  end
end

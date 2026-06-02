class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || home_path
  end

  def after_sign_up_path_for(resource)
    home_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def current_group
    return @current_group if defined?(@current_group)
  
    @current_group =
      if session[:group_id]
        current_user.groups.find_by(id: session[:group_id])
      end
  
    @current_group ||= current_user.groups.first
  end

  helper_method :current_group

  private

  def reject_guest_user
    if user_signed_in? && current_user.guest?
      redirect_to guest_signup_prompt_path,
                  alert: "この機能は会員登録が必要です"
    end
  end
end

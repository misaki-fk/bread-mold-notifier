class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      if user.persisted? && user.line_user_id.blank?
        Notification.create!(
          user: user,
          notification_type: "system",
          message: Notification.line_promo_message
        )
      end
    end
  end
end
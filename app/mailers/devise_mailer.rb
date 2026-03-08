class DeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts = {})
    reset_url = edit_user_password_url(record, reset_password_token: token)

    unless Rails.env.test?
      Resend::Emails.send({
        from: "Pankabi <onboarding@resend.dev>",
        to: [record.email],
        subject: "【Pankabi】パスワード再設定",
        html: "<p>パスワード再設定はこちら</p><a href='#{reset_url}'>#{reset_url}</a>"
      })
    end
  end
end
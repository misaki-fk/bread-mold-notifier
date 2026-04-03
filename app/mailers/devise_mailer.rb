class DeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts = {})
    return super if Rails.env.test?

    reset_url = edit_user_password_url(record, reset_password_token: token)

    Resend::Emails.send({
      from: "Pankabi <no-reply@pankabi.com>",
      to: [record.email],
      subject: "【Pankabi】パスワード再設定",
      html: "<p>パスワード再設定はこちら</p><a href='#{reset_url}'>#{reset_url}</a>"
    })
  end
end
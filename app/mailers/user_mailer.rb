class UserMailer < ApplicationMailer

  def password_reset(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Reset Your Password')
  end

  def email_confirm(email)
    mail(to: email, subject: 'Check Your Email')
  end

  def email_token(email, token)
    @token = token
    mail(to: email, subject: 'Check Your Email')
  end

end

class UserMailer < ApplicationMailer

  def password_reset(user)
    @user = user
    @user.update_reset_token
    mail(to: @user.email, subject: 'Reset Your Password')
  end

  def email_confirm(user)
    @user = user
    @user.update_confirm_token
    mail(to: @user.email, subject: 'Check Your Email')
  end

end
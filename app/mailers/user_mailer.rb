class UserMailer < ApplicationMailer

  def password_reset(user_id)
    @user = User.find(user_id)
    @user.
    mail(to: @user.email, subject: 'Reset Your Password')
  end

  def email_confirm(user_id)
    @user = User.find(user_id)
    @user.create_confirm_token
    mail(to: @user.email, subject: 'Check Your Email')
  end

end
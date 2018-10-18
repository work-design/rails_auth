class UserMailer < ApplicationMailer

  def password_reset(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Reset Your Password')
  end

  def email_confirm(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Check Your Email')
  end

end

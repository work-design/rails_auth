class UserMailer < ApplicationMailer

  def password_reset(account)
    mail(to: account.identity, subject: 'Reset Your Password')
  end

  def email_confirm(email)
    mail(to: email, subject: 'Check Your Email')
  end

  def email_token(email, token)
    @token = token
    mail(to: email, subject: 'Check Your Email')
  end

end

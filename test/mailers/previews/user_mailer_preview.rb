class UserMailerPreview < ActionMailer::Preview

  def email_token
    UserMailer.email_token('test@work.design', '123456')
  end
  
end

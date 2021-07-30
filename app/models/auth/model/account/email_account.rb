module Auth::Model::Account::EmailAccount
  extend ActiveSupport::Concern

  def reset_notice
    UserMailer.password_reset(self).deliver_later
  end

  # 邮件发送的 reset_token
  def reset_token
    authorized_token.token = SecureRandom.uuid
    authorized_token.expire_at = 10.minutes.since
    authorized_token.save
    authorized_token.token
  end

end

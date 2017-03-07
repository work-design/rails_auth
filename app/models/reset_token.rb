class ConfirmToken < VerifyToken

  def update_reset_token
    self.token = SecureRandom.uuid
    self.expired_at = 10.minutes.since
    save
  end

end

module RailsAuth::VerifyToken::ResetToken

  def update_token
    self.user_id = self.account.user_id
    self.token = SecureRandom.uuid
    self.expire_at = 10.minutes.since
    self
  end

end

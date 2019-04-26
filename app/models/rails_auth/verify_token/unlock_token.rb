module RailsAuth::VerifyToken::UnlockToken

  def update_token
    self.user_id = self.account.user_id
    self.token = SecureRandom.uuid
    self.expired_at = 10.minutes.since
    self
  end

end

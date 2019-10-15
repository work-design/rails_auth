module RailsAuth::VerifyToken::ResetToken

  def update_token
    self.token = SecureRandom.uuid
    self.expire_at = 10.minutes.since
    super
    self
  end

end

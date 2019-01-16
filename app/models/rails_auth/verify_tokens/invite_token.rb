class InviteToken < VerifyToken

  def update_token
    self.token = SecureRandom.hex 4
    self.expired_at = 1.year.since
    self
  end

end unless RailsAuth.config.disabled_models.include?('InviteToken')

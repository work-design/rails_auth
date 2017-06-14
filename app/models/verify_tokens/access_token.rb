class AccessToken < VerifyToken

  def update_token
    self.expired_at = 1.months.since
    self.token = user.generate_auth_token(sub: 'auth', exp: expired_at.to_i)
  end

end

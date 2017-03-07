class MobileToken < VerifyToken

  def update_token
    self.token = rand(10000..999999)
    self.expired_at = 10.minutes.since
  end

end

class MobileToken < VerifyToken
  validates :identity, presence: true

  def update_token
    self.identity ||= self.account.identity
    self.user_id = self.account.user_id
    self.token = rand(10000..999999)
    self.expired_at = 10.minutes.since
    self
  end

  def verify_token?
    user.update(mobile_confirm: true)
  end

  def send_out
    puts "sends sms here #{token}"
    true
  end

end unless RailsAuth.config.disabled_models.include?('MobileToken')

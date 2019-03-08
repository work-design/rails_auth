class MobileToken < VerifyToken
  validates :account, presence: true

  def update_token
    self.account = self.user.mobile if self.user
    self.token = rand(10000..999999)
    self.expired_at = 10.minutes.since
    self
  end

  def verify_token?
    user.update(mobile_confirm: true)
  end

  def send_sms
    puts 'sends sms here'
    true
  end

  def save_with_send
    save
    send_sms
  end

end unless RailsAuth.config.disabled_models.include?('MobileToken')

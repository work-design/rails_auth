class MobileToken < VerifyToken
  validates :account, presence: true

  after_initialize do
    if self.user
      self.account = self.user.mobile
    end
  end
  before_create :update_token

  def update_token
    self.token = rand(10000..999999)
    self.expired_at = 10.minutes.since
  end

  def verify_token?
    user.update(mobile_confirm: true)
  end

  def send_sms
    'sends sms here'
  end

end unless RailsAuth.config.disabled_models.include?('MobileToken')

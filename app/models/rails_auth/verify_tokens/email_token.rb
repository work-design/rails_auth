class EmailToken < VerifyToken
  validates :account, presence: true

  after_initialize do
    if self.user
      self.account = self.user.email
    end
  end

  def update_token
    self.token = rand(10000..999999)
    self.expired_at = 10.minutes.since
  end

  def verify_token?
    user.update(email_confirm: true)
  end

  def send_email
    UserMailer.email_token(self.account, self.token).deliver_later
  end

  def save_with_send
    save
    send_email
  end

end unless RailsAuth.config.disabled_models.include?('EmailToken')

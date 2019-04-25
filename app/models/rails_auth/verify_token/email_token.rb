module RailsAuth::VerifyToken::EmailToken
  validates :identity, presence: true

  def update_token
    self.identity ||= self.account.identity
    self.user_id = self.account.user_id
    self.token = rand(10000..999999)
    self.expired_at = 10.minutes.since
    self
  end

  def verify_token?
    user.update(email_confirm: true)
  end

  def send_out
    UserMailer.email_token(self.identity, self.token).deliver_later
  end

end

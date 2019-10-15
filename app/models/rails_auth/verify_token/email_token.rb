module RailsAuth::VerifyToken::EmailToken
  extend ActiveSupport::Concern
  included do
    validates :identity, presence: true
  end
  
  def update_token
    self.token = rand(10000..999999)
    self.expire_at = 10.minutes.since
    super
    self
  end

  def verify_token?
    user.update(email_confirm: true)
  end

  def send_out
    UserMailer.email_token(self.identity, self.token).deliver_later
  end

end

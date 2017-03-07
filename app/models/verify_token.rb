class VerifyToken < ApplicationRecord
  belongs_to :user

  def update_token
    self.token = SecureRandom.uuid
    self.expired_at = 14.days.since
    save
  end

  def verify_token?(now = Time.now)
    return false if self.expired_at.blank?
    if now > self.expired_at
      self.errors.add(:token, 'The token has expired')
      return false
    end

    true
  end

  def clear_token!
    update(token: '')
  end

end

class VerifyToken < ApplicationRecord
  belongs_to :user, optional: true


  scope :valid, -> { where('expired_at >= ?', Time.now) }
  before_create :update_token

  def update_token
    self.token = SecureRandom.uuid
    self.expired_at = 14.days.since
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
    self.destroy
  end

end

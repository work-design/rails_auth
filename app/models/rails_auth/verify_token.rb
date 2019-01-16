# Deal with token
#
# 用于处理Token
class VerifyToken < ApplicationRecord
  belongs_to :user, optional: true

  scope :valid, -> { where('expired_at >= ?', Time.now).order(access_counter: :asc) }
  validates :token, presence: true
  after_initialize :update_token, if: -> { new_record? }

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

end unless RailsAuth.config.disabled_models.include?('VerifyToken')

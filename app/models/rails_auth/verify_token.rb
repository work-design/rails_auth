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
    self
  end

  def verify_token?(now = Time.now)
    return false if self.expired_at.blank?
    if now > self.expired_at
      self.errors.add(:token, 'The token has expired')
      return false
    end

    true
  end

  def send_out
    raise 'should implement in subclass'
  end

  def self.create_with_account(account)
    verify_token = self.valid.find_by(account: account)
    return verify_token if verify_token
    verify_token = self.new(account: account)
    self.transaction do
      self.where(account: account).delete_all
      verify_token.save
    end
    verify_token
  end

end unless RailsAuth.config.disabled_models.include?('VerifyToken')

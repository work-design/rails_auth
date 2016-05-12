module TheAuthUser
  extend ActiveSupport::Concern

  included do
    include ActiveModel::SecurePassword
    attr_accessor :remember_me

    validates :email, uniqueness: true, if: -> { email.present? }
    validates :mobile, uniqueness: true, if: -> { mobile.present? }
    has_secure_password validations: false
  end


  def update_reset_token
    self.reset_token = SecureRandom.uuid
    self.reset_token_expired_at = 10.minutes.since
    save
  end

  def verify_reset_token?(now = Time.now)
    self.reset_token_expired_at ||= Time.now
    if now > self.reset_token_expired_at
      self.errors.add(:reset_token, 'Reset Token has expired')
      return false
    end

    true
  end

  def clear_reset_token!
    update(reset_token: '')
  end


end


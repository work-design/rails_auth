module TheAuthUser
  extend ActiveSupport::Concern

  included do
    include ActiveModel::SecurePassword
    attr_accessor :remember_me

    validates :email, uniqueness: true, if: -> { email.present? }
    validates :mobile, uniqueness: true, if: -> { mobile.present? }
    has_secure_password validations: false
  end

  def update_confirm_token
    self.confirm_token = SecureRandom.uuid
    self.confirm_token_expired_at = 14.days.since
    save
  end

  def verify_confirm_token?(now = Time.now)
    self.confirm_token_expired_at ||= Time.now
    if now > self.confirm_token_expired_at
      self.errors.add(:confirm_token, 'Confirm Token has expired')
      return false
    end

    true
  end

  def email_confirm_update!
    update(email_confirm: true, confirm_token: '')
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


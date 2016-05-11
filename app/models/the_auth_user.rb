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
  end

  def verify_reset_token?(now = Time.now)
    unless now <= self.auth_code_expired_at
      self.errors.add(:auth_code, '验证码已过期')
      return false
    end

    update(reset_token: '')
  end


end


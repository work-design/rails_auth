module TheAuthUser
  extend ActiveSupport::Concern

  included do
    include ActiveModel::SecurePassword
    include JwtToken
    alias_attribute :identifier, :id

    has_secure_password validations: false

    validates :email, uniqueness: true, if: -> { email.present? && email_changed? }
    validates :mobile, uniqueness: true, if: -> { mobile.present? && mobile_changed? }
    validates :password, confirmation: true, length: { in: 6..72 }, allow_blank: true

    has_one  :confirm_token, -> { valid }
    has_many :confirm_tokens, dependent: :delete_all

    has_one  :reset_token, -> { valid }
    has_many :reset_tokens, dependent: :delete_all

    has_one  :mobile_token, -> { valid }
    has_many :mobile_tokens, dependent: :delete_all

    has_one  :access_token, -> { valid }
    has_many :access_tokens, dependent: :delete_all

    has_many :oauth_users, dependent: :nullify
  end

  def get_access_token
    if self.access_token
      self.access_token.token
    else
      self.access_tokens.delete_all
      create_access_token.token
    end
  end

  def get_reset_token
    if self.reset_token
      self.reset_token.token
    else
      self.reset_tokens.delete_all
      create_reset_token.token
    end
  end

  def get_confirm_token
    if self.confirm_token
      self.confirm_token.token
    else
      self.confirm_tokens.delete_all
      create_confirm_token.token
    end
  end

  def get_mobile_token
    if self.mobile_token
      self.mobile_token.token
    else
      self.mobile_tokens.delete_all
      create_mobile_token.token
    end
  end

  def join(params = nil)
    self.errors.add(:password, :blank) unless self.password_digest.present?
    save
  end

  def can_login?(params)
    if verified_status?
      return false
    end

    if authenticate(params[:password])
      self
    else
      errors.add :login, 'Incorrect email or password.'
      false
    end
  end

  def verified_status?
    if self.disabled?
      errors.add :login, 'The account has been disabled!'
      true
    else
      false
    end
  end

end


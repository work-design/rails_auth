module TheAuthUser
  extend ActiveSupport::Concern

  included do
    include ActiveModel::SecurePassword
    include JwtToken
    alias_attribute :identifier, :id

    validates :email, uniqueness: true, if: -> { email.present? && email_changed? }
    validates :mobile, uniqueness: true, if: -> { mobile.present? && mobile_changed? }
    has_secure_password validations: false

    has_one  :confirm_token
    has_many :confirm_tokens

    has_one  :reset_token
    has_many :reset_tokens

    has_one  :mobile_token
    has_many :mobile_tokens

    has_one  :access_token
    has_many :access_tokens

    has_many :oauth_users, dependent: :nullify
  end

  def get_access_token
    if self.access_token&.verify_token?
      self.access_token.token
    else
      self.class.transaction do
        self.access_token&.destroy
        create_access_token.token
      end
    end
  end

  def get_reset_token
    if self.reset_token&.verify_token?
      self.reset_token.token
    else
      self.class.transaction do
        self.reset_token&.destroy
        create_reset_token.token
      end
    end
  end

  def get_confirm_token
    if self.confirm_token&.verify_token?
      self.confirm_token.token
    else
      self.class.transaction do
        self.confirm_token&.destroy
        create_confirm_token.token
      end
    end
  end

  def email_confirm_update!
    update(email_confirm: true)
  end

  def join(params)
    save
  end

  def can_login?(params)
    if self.disabled?
      errors.add :login, 'The account has been disabled!'
      return false
    end

    if authenticate(params[:password])
      self
    else
      errors.add :login, 'Incorrect email or password.'
      false
    end
  end

end


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
  end


  def get_access_token
    self.class.transaction do
      access_token.destroy
      create_access_token
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


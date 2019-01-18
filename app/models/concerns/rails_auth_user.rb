##
# include this module to your User model
#   class User < ApplicationRecord
#     include RailsAuthUser
#   end
module RailsAuthUser
  extend ActiveSupport::Concern

  included do
    include ActiveModel::SecurePassword
    has_secure_password validations: false

    validates :email, uniqueness: true, if: -> { email.present? && email_changed? }
    validates :email, presence: true, if: -> { mobile.blank? }
    validates :mobile, uniqueness: true, if: -> { mobile.present? && mobile_changed? }
    validates :mobile, presence: true, if: -> { email.blank? }
    validates :password, confirmation: true, length: { in: 6..72 }, allow_blank: true

    has_one :unlock_token, -> { valid }
    has_many :unlock_tokens, dependent: :delete_all

    has_one :reset_token, -> { valid }
    has_many :reset_tokens, dependent: :delete_all

    has_one :mobile_token, -> { valid }
    has_many :mobile_tokens, dependent: :delete_all

    has_one :email_token, -> { valid }
    has_many :email_tokens, dependent: :delete_all

    has_one :access_token, -> { valid }
    has_many :access_tokens, dependent: :delete_all

    has_many :verify_tokens, autosave: true, dependent: :delete_all
    has_many :oauth_users, dependent: :nullify

    has_one_attached :avatar

    before_save :invalid_access_token, if: -> { password_digest_changed? }
  end

  def access_token
    if super
      super
    else
      VerifyToken.transaction do
        self.access_tokens.delete_all
        create_access_token
      end
    end
  end

  def auth_token
    access_token.token
  end

  def reset_token
    if super
      super
    else
      VerifyToken.transaction do
        self.reset_tokens.delete_all
        create_reset_token
      end
    end
  end

  def unlock_token
    if super
      super
    else
      VerifyToken.transaction do
        self.unlock_tokens.delete_all
        create_unlock_token
      end
    end
  end

  def mobile_token
    if super
      super
    else
      VerifyToken.transaction do
        self.mobile_tokens.delete_all
        create_mobile_token
      end
    end
  end

  def email_token
    if super
      super
    else
      VerifyToken.transaction do
        self.email_tokens.delete_all
        create_email_token
      end
    end
  end

  def join(params = {})
    self.assign_attributes params.slice(
      :name,
      :email,
      :mobile,
      :password,
      :password_confirmation
    )
    save
  end

  ##
  # pass login params to this method;
  def can_login?(params)
    if verified_status?
      return false
    end

    if password_digest? && params[:password].present?
      if authenticate(params[:password])
        self
      else
        errors.add :base, :wrong_name_or_password
        return false
      end
    elsif params[:token].present?
      if authenticate_by_token(params[:token])
        self
      else
        errors.add :base, :wrong_token
        return false
      end
    else
      errors.add :base, :token_blank
      false
    end
  end

  def verified_status?
    if self.disabled?
      errors.add :base, :account_disable
      true
    else
      false
    end
  end

  def authenticate_by_token(token)
    mobile_token = self.mobile_tokens.valid.find_by(token: token)
    if mobile_token
      self.update(mobile_confirmed: true)
    else
      false
    end
  end

  def avatar_url
    avatar.service_url if avatar.attachment.present?
  end

  def oauth_providers
    OauthUser.options_i18n(:provider).values.map(&:to_s) - oauth_users.pluck(:provider).compact
  end

  def invalid_access_token
    self.access_tokens.delete_all
  end

  def generate_auth_token(**options)
    JwtHelper.generate_jwt_token(id, password_digest, options)
  end

end


##
# include this module to your User model
#   class User < ApplicationRecord
#     include RailsAuth::User
#   end
module RailsAuth::User
  extend ActiveSupport::Concern

  included do
    delegate :url_helpers, to: 'Rails.application.routes'
    include ActiveModel::SecurePassword
    has_secure_password validations: false

    attribute :locale, :string, default: I18n.default_locale
    attribute :timezone, :string

    validates :password, confirmation: true, length: { in: 6..72 }, allow_blank: true

    has_one :unlock_token, -> { valid }
    has_many :unlock_tokens
    has_many :reset_tokens
    has_many :access_tokens, dependent: :delete_all
    has_many :verify_tokens, autosave: true, dependent: :delete_all
    has_many :oauth_users, dependent: :nullify
    has_many :accounts, dependent: :nullify

    accepts_nested_attributes_for :accounts
    
    has_one_attached :avatar

    before_save :invalid_access_token, if: -> { password_digest_changed? }
  end

  def unlock_token
    if super
      super
    else
      ::VerifyToken.transaction do
        self.unlock_tokens.delete_all
        create_unlock_token
      end
    end
  end

  def auth_tokens
    access_tokens.pluck(:token)
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
    if restrictive?
      return false
    end

    if password_digest? && params[:password].present?
      if authenticate(params[:password])
        self
      else
        errors.add :base, :wrong_name_or_password
        return false
      end
    else
      errors.add :base, :token_blank
      false
    end
  end

  def restrictive?
    if self.disabled?
      errors.add :base, :account_disable
      true
    else
      false
    end
  end

  def avatar_url
    url_helpers.rails_blob_url(avatar) if avatar.attachment.present?
  end

  def valid_providers
    ::OauthUser.options_i18n(:provider).values.map(&:to_s) - oauth_providers
  end

  def invalid_access_token
    self.access_tokens.delete_all
  end

  def generate_auth_token(**options)
    JwtHelper.generate_jwt_token(id, password_digest, options)
  end
  
  def account_identities
    accounts.map(&:identity)
  end

  def oauth_providers
    oauth_users.pluck(:provider).compact
  end

end


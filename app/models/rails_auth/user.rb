##
# include this module to your User model
#   class User < ApplicationRecord
#     include RailsAuth::User
#   end
module RailsAuth::User
  extend ActiveSupport::Concern

  included do
    include ActiveModel::SecurePassword
    has_secure_password validations: false

    attribute :locale, :string, default: I18n.default_locale
    attribute :timezone, :string

    validates :password, confirmation: true, length: { in: 6..72 }, allow_blank: true

    has_many :access_tokens, dependent: :delete_all
    has_many :verify_tokens, autosave: true, dependent: :delete_all
    has_many :oauth_users, dependent: :nullify
    has_many :accounts, dependent: :nullify
    accepts_nested_attributes_for :accounts
    
    has_many :user_taggeds, dependent: :destroy
    has_many :user_tags, through: :user_taggeds
    
    has_one_attached :avatar

    before_save :invalid_access_token, if: -> { password_digest_changed? }
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
    if params[:password].blank?
      errors.add :base, :password_blank
      return false
    end
    
    if password_digest.blank?
      errors.add :base, :password_reject
    end
    
    unless authenticate(params[:password])
      errors.add :base, :wrong_name_or_password
      return false
    end

    if restrictive?
      errors.add :base, :account_disable
      return false
    end
    
    self
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
    avatar.service_url if avatar.attachment.present?
  rescue ArgumentError
    ''
  end

  def valid_providers
    ::OauthUser.options_i18n(:provider).values.map(&:to_s) - oauth_providers
  end

  def invalid_access_token
    self.access_tokens.delete_all
  end
  
  def account_identities
    accounts.map(&:identity)
  end

  def oauth_providers
    oauth_users.pluck(:provider).compact
  end

end


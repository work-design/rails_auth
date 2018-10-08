##
# include this module to your User model
#   class User < ApplicationRecord
#     include RailsAuthUser
#   end
module RailsAuthUser
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

    has_many :verify_tokens, autosave: true, dependent: :delete_all
    has_many :oauth_users, dependent: :nullify
  end

  def access_token
    if super
      super
    else
      self.access_tokens.delete_all
      create_access_token
    end
  end

  def reset_token
    if super
      super
    else
      self.reset_tokens.delete_all
      create_reset_token
    end
  end

  def confirm_token
    if super
      super
    else
      self.confirm_tokens.delete_all
      create_confirm_token
    end
  end

  def mobile_token
    if super
      super
    else
      self.mobile_tokens.delete_all
      create_mobile_token
    end
  end

  def join(params = nil)
    self.errors.add(:password, :blank) unless self.password_digest.present?
    save
  end

  ##
  # pass login params to this method;
  def can_login?(params)
    if verified_status?
      return false
    end

    if authenticate(params[:password])
      self
    else
      errors.add :base, 'Incorrect account or password.'
      false
    end
  end

  def verified_status?
    if self.disabled?
      errors.add :base, 'The account has been disabled!'
      true
    else
      false
    end
  end

  def oauth_providers
    OauthUser.options_i18n(:provider).values.map(&:to_s) - oauth_users.pluck(:provider).compact
  end

end


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

    has_one  :unlock_token, -> { valid }
    has_many :unlock_tokens, dependent: :delete_all

    has_one  :reset_token, -> { valid }
    has_many :reset_tokens, dependent: :delete_all

    has_one  :mobile_token, -> { valid }
    has_many :mobile_tokens, dependent: :delete_all

    has_one  :access_token, -> { valid }
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
      self.access_tokens.delete_all
      create_access_token
    end
  end

  def auth_token
    access_token.token
  end

  def reset_token
    if super
      super
    else
      self.reset_tokens.delete_all
      create_reset_token
    end
  end

  def unlock_token
    if super
      super
    else
      self.unlock_tokens.delete_all
      create_unlock_token
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
    self.assign_attributes params
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
        errors.add :base, 'Incorrect account or password!'
        return false
      end
    elsif params[:token].present?
      if authenticate_by_token(params[:token])
        self
      else
        errors.add :base, 'Incorrect Token!'
        return false
      end
    else
      errors.add :base, 'Your must provide password or token!'
      false
    end
  end

  def verified_status?
    if self.disabled?
      errors.add :base, 'Your account has been disabled!'
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

end


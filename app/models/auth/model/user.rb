module Auth
  module Model::User
    extend ActiveSupport::Concern

    included do
      include ActiveModel::SecurePassword
      has_secure_password validations: false

      attribute :name, :string
      attribute :password_digest, :string
      attribute :locale, :string, default: I18n.default_locale
      attribute :timezone, :string
      attribute :last_login_at, :datetime
      attribute :last_login_ip, :string
      attribute :disabled, :boolean, default: false
      attribute :source, :string
      attribute :invited_code, :string

      has_many :accounts, inverse_of: :user, dependent: :nullify
      has_many :verify_tokens, through: :accounts
      has_many :authorized_tokens, through: :accounts
      has_many :oauth_users
      has_many :confirmed_accounts, -> { where(confirmed: true) }, class_name: 'Account'
      accepts_nested_attributes_for :accounts

      has_many :user_taggeds, dependent: :destroy_async
      has_many :user_tags, through: :user_taggeds

      has_one_attached :avatar

      validates :password, confirmation: true, length: { in: 6..72 }, allow_blank: true

      before_save :invalid_authorized_token, if: -> { password_digest_changed? }
    end

    ##
    # pass login params to this method;
    def can_login?(password)
      if disabled?
        errors.add :base, :account_disable
        return false
      end

      if authenticate(password)
        self.last_login_at = Time.current
        self.save
        self
      else
        errors.add :base, :wrong_name_or_password
        false
      end
    end

    def valid_providers
      OauthUser.options_i18n(:provider).values.map(&:to_s) - oauth_providers
    end

    def info_blank?
      oauth_users.map(&:info_blank?).all? true
    end

    def invalid_authorized_token
      self.authorized_tokens.destroy
    end

    def account_identities
      (confirmed_accounts.map(&:identity) + oauth_users.pluck(:identity).compact).uniq
    end

    def oauth_providers
      oauth_users.pluck(:provider).compact
    end

    def avatar_url
      avatar.url
    end

  end
end

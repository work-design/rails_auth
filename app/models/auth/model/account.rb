module Auth
  module Model::Account
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :identity, :string, index: true
      attribute :confirmed, :boolean, default: false
      attribute :primary, :boolean, default: false
      attribute :source, :string

      belongs_to :user, optional: true
      has_one :authorized_token, foreign_key: :identity, primary_key: :identity
      has_many :authorized_tokens, foreign_key: :identity, primary_key: :identity
      has_many :verify_tokens, dependent: :delete_all
      has_many :oauth_users, dependent: :nullify, inverse_of: :account

      scope :without_user, -> { where(user_id: nil) }
      scope :confirmed, -> { where(confirmed: true) }

      validates :identity, presence: true
      validate :validate_identity

      after_save :set_primary, if: -> { self.primary? && saved_change_to_primary? }
      after_update :sync_user, if: -> { saved_change_to_user_id? }
    end

    def set_primary
      return unless user_id
      self.class.base_class.unscoped.where.not(id: self.id).where(user_id: self.user_id).update_all(primary: false)
    end

    def sync_user
      self.oauth_users.update_all(user_id: self.user_id)
      self.verify_tokens.update_all(user_id: self.user_id)
      self.authorized_tokens.update_all(user_id: self.user_id)
    end

    def can_login_by_password?
      confirmed && user && user.password_digest.present?
    end

    def verify_token?(token)
      check_token = self.verify_tokens.valid.find_by(token: token)
      if check_token
        self.confirmed = true
      else
        self.errors.add :base, :wrong_token
        false
      end
    end

    def can_login?(params = {})
      if params[:token].present?
        if verify_token?(params[:token])
          user || build_user
          user.assign_attributes params.slice(:name, :password, :password_confirmation, :invited_code)
          self.primary = true if user.new_record?
        end
      end

      if params[:password].present?
        unless user.can_login?(params[:password])
          return false
        end
      end

      if params[:uid].present?
        bind_oauth_user(params[:uid])
      end

      user
    end

    def bind_oauth_user(uid)
      oauth_user = OauthUser.find_by uid: uid
      if oauth_user
        oauth_user.account = self
        oauth_user.save
      end
    end

    def xx
      if params[:device_id]
        account = DeviceAccount.find_by identity: params[:device_id]
        self.user = account.user if account
      end
    end

    def verify_token
      r = check_tokens.order(expire_at: :desc).first
      if r
        if r.verify_token?
          r
        else
          r.update_token!
        end
      else
        check_tokens.create
      end
    end

    def authorized_token
      r = super || create_authorized_token
      if r.verify_token?
        return r
      else
        r.update_token!
      end

      r
    end

    def auth_token
      authorized_token.token
    end

    def reset_token
    end

    def reset_notice
      p 'Should implement in subclass'
    end

    def validate_identity
      if self.class.where.not(id: self.id).where(confirmed: true).exists?(identity: identity)
        errors.add(:identity, :taken)
      end
    end

  end
end

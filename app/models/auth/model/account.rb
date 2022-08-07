module Auth
  module Model::Account
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :identity, :string, index: true
      attribute :confirmed, :boolean, default: false
      attribute :source, :string

      belongs_to :user, optional: true

      has_one :disposable_token, foreign_key: :identity, primary_key: :identity, dependent: :delete
      has_many :authorized_tokens, foreign_key: :identity, primary_key: :identity, dependent: :delete_all
      has_many :verify_tokens, foreign_key: :identity, primary_key: :identity, dependent: :delete_all
      has_many :oauth_users, foreign_key: :identity, primary_key: :identity, inverse_of: :account

      scope :without_user, -> { where(user_id: nil) }
      scope :confirmed, -> { where(confirmed: true) }

      validates :identity, presence: true, uniqueness: { scope: [:confirmed] }

      # belongs_to 的 autosave 是在 before_save 中定义的
      #
      after_validation :init_user, if: -> { confirmed? && confirmed_changed? }
      after_save_commit :sync_user_later, if: -> { saved_change_to_user_id? }
    end

    def sync_user_later
      AccountSyncUserJob.perform_later(self)
    end

    def sync_user
    end

    def last?
      user.accounts.where.not(id: self.id).empty?
    end

    def can_login_by_password?
      confirmed && user && user.password_digest.present?
    end

    def init_user
      user || build_user
    end

    def can_login_by_token(token: , **params)
      check_token = self.verify_tokens.valid.find_by(token: token)

      if check_token
        user || build_user
        user.assign_attributes params.slice(:name, :password, :password_confirmation, :invited_code)
        user.last_login_at = Time.current
        self.confirmed = true

        self.class.transaction do
          user.save!
          self.save!
        end

        user
      else
        self.errors.add :base, :wrong_token
        false
      end
    end

    def can_login_by_password?(password:, **params)
      if user.can_login?(params[:password])
        user.last_login_at = Time.current
        user.save
        user
      end

      if params[:uid].present?
        oauth_user = OauthUser.find_by uid: params[:uid]
        oauth_user.identity = params[:identity]
      end
    end

    def xx
      if params[:device_id]
        account = DeviceAccount.find_by identity: params[:device_id]
        self.user = account.user if account
      end
    end

    def authorized_token
      authorized_tokens.valid.take || authorized_tokens.create
    end

    def auth_token
      authorized_token.token
    end

    def once_token
      disposable_token || create_disposable_token
      disposable_token.id
    end

    def reset_token
    end

    def reset_notice
      p 'Should implement in subclass'
    end

    class_methods do

      def build_with_identity(identity)
        account = self.find_by(identity: identity)
        return account if account

        type = if identity.to_s.include?('@')
          'Auth::EmailAccount'
        else
          'Auth::MobileAccount'
        end
        self.new(type: type, identity: identity)
      end

    end

  end
end

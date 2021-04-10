module Auth
  module Model::Account
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :identity, :string, index: true
      attribute :confirmed, :boolean, default: false
      attribute :source, :string

      belongs_to :user, optional: true
      belongs_to :inviter, class_name: 'User', optional: true
      has_many :authorized_tokens, foreign_key: :identity, primary_key: :identity

      has_many :verify_tokens, foreign_key: :identity, primary_key: :identity, dependent: :delete_all
      has_many :oauth_users, dependent: :nullify, inverse_of: :account

      scope :without_user, -> { where(user_id: nil) }
      scope :confirmed, -> { where(confirmed: true) }

      validates :identity, presence: true, uniqueness: { scope: [:confirmed] }
    end

    def last?
      user.accounts.where.not(id: self.id).empty?
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
        else
          return false
        end
      end

      if params[:password].present?
        unless user.can_login?(params[:password])
          return false
        end
      end
      user.last_login_at = Time.current

      if params[:uid].present?
        oauth_user = OauthUser.find_by uid: params[:uid]
        if oauth_user
          oauth_user.request_id ||= params[:request_id]
          oauth_user.account = self
          self.class.transaction do
            self.save!
            oauth_user.save!
          end
        end
      else
        self.save
      end

      user
    end

    def xx
      if params[:device_id]
        account = DeviceAccount.find_by identity: params[:device_id]
        self.user = account.user if account
      end
    end

    def verify_token
      check_tokens.valid.take || check_tokens.create
    end

    def authorized_token
      authorized_tokens.valid.take || authorized_tokens.create
    end

    def auth_token
      authorized_token.token
    end

    def reset_token
    end

    def reset_notice
      p 'Should implement in subclass'
    end

  end
end

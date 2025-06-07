module Auth
  module Model::Account
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :identity, :string, index: true
      attribute :confirmed, :boolean, default: false
      attribute :source, :string
      index [:identity, :confirmed]

      belongs_to :user, optional: true

      has_many :authorized_tokens, ->(o) { where(user_id: o.user_id) }, primary_key: :identity, foreign_key: :identity, dependent: :delete_all
      has_many :verify_tokens, primary_key: :identity, foreign_key: :identity, dependent: :delete_all
      has_many :oauth_users, primary_key: :identity, foreign_key: :identity, inverse_of: :account

      scope :without_user, -> { where(user_id: nil) }
      scope :with_user, -> { where.not(user_id: nil) }
      scope :confirmed, -> { where(confirmed: true) }

      validates :identity, presence: true, uniqueness: { scope: [:user_id] }

      # belongs_to 的 autosave 是在 before_save 中定义的
      #
      after_validation :init_user, if: -> { confirmed? && confirmed_changed? }
    end

    def last?
      user.accounts.where.not(id: self.id).empty?
    end

    def init_user
      user || build_user
    end

    def can_login_by_token?(**params)
      user || build_user
      user.assign_attributes params.slice(
        'name',
        'password',
        'password_confirmation',
        'invited_code'
      ) # 这里必须用 String 类型，因为params 转义过来的hash key 是字符
      user.last_login_at = Time.current
      self.confirmed = true

      self.class.transaction do
        user.save!
        self.save!
      end

      user
    end

    def can_login_by_password?(password)
      user.can_login?(password)
    end

    def xx
      if params[:device_id]
        account = DeviceAccount.find_by identity: params[:device_id]
        self.user = account.user if account
      end
    end

    def authorized_token
      authorized_tokens.find(&:effective?) || authorized_tokens.create
    end

    def auth_token
      authorized_token.id
    end

    def once_token
      auth_token
    end

    def verify_token
      verify_tokens.find(&:effective?) || verify_tokens.create
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

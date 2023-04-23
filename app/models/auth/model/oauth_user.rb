module Auth
  module Model::OauthUser
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :provider, :string
      attribute :uid, :string
      attribute :unionid, :string, index: true
      attribute :appid, :string
      attribute :name, :string
      attribute :avatar_url, :string
      attribute :state, :string
      attribute :access_token, :string
      attribute :expires_at, :datetime
      attribute :refresh_token, :string
      attribute :extra, :json, default: {}
      attribute :identity, :string, index: true
      index [:uid, :provider], unique: true

      belongs_to :account, -> { where(confirmed: true) }, foreign_key: :identity, primary_key: :identity, inverse_of: :oauth_users, optional: true
      belongs_to :user, optional: true

      #has_one :user, through: :account
      has_many :authorized_tokens, ->(o) { where(appid: o.appid, identity: o.identity) }, primary_key: :uid, foreign_key: :uid, dependent: :delete_all
      has_one :same_oauth_user, ->(o) { where.not(id: o.id).where.not(unionid: nil).where.not(identity: nil) }, class_name: self.name, foreign_key: :unionid, primary_key: :unionid
      has_many :same_oauth_users, ->(o) { where.not(id: o.id).where.not(unionid: nil) }, class_name: self.name, foreign_key: :unionid, primary_key: :unionid

      has_many :members, class_name: 'Org::Member', foreign_key: :identity, primary_key: :identity

      validates :provider, presence: true
      validates :uid, presence: true

      after_save :sync_to_authorized_tokens, if: -> { saved_change_to_identity? }
      after_save :sync_name_to_user, if: -> { saved_change_to_name? }
      after_save_commit :sync_avatar_to_user_later, if: -> { avatar_url.present? && saved_change_to_avatar_url? }
    end

    def generate_account!
      user || build_user
      user.assign_attributes(name: name)
      save
    end

    def can_login?(params)
      self.identity = params[:identity]
    end

    def sync_name_to_user
      return unless user
      user.name ||= name
      user.save
    end

    def sync_avatar_to_user
      return unless user
      user.avatar.url_sync(avatar_url) unless user.avatar.attached?
    end

    def sync_avatar_to_user_later
      UserCopyAvatarJob.perform_later(self)
    end

    def info_blank?
      attributes['name'].blank? && attributes['avatar_url'].blank?
    end

    def sync_to_authorized_tokens
      authorized_tokens.update_all(identity: identity)
    end

    def save_info(info_params)
    end

    def strategy
    end

    def authorized_token
      authorized_tokens.find(&->(i){ i.expire_at.present? && i.expire_at > Time.current }) || authorized_tokens.create
    end

    def auth_token
      authorized_token.id
    end

    def refresh_token!
      client = strategy
      token = OAuth2::AccessToken.new client, self.access_token, { expires_at: self.expires_at.to_i, refresh_token: self.refresh_token }
      token.refresh!
    end

  end
end

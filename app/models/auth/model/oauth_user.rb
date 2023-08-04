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

      belongs_to :user, optional: true
      belongs_to :account, -> { where(confirmed: true) }, foreign_key: :identity, primary_key: :identity, inverse_of: :oauth_users, optional: true

      has_many :authorized_tokens, ->(o) { where(o.filter_hash) }, primary_key: :uid, foreign_key: :uid, dependent: :delete_all
      belongs_to :same_oauth_user, ->(o) { where.not(id: o.id) }, class_name: self.name, foreign_key: :unionid, primary_key: :unionid, optional: true
      has_many :same_oauth_users, class_name: self.name, primary_key: :unionid, foreign_key: :unionid

      validates :provider, presence: true
      validates :uid, presence: true

      before_save :auto_link, if: -> { unionid.present? && unionid_changed? }
      after_save :generate_account!, if: -> { saved_change_to_identity? }
      after_save :sync_to_authorized_tokens, if: -> { saved_change_to_identity? }
      after_save :sync_name_to_user, if: -> { name.present? && saved_change_to_name? }
      after_save_commit :sync_avatar_to_user_later, if: -> { avatar_url.present? && saved_change_to_avatar_url? }
    end

    def filter_hash
      {
        appid: appid,
        user_id: user_id,
        identity: identity
      }.compact_blank
    end

    def generate_account!
      account || build_account(type: 'Auth::MobileAccount')
      account.user_id = user_id
      account.save
    end

    def can_login?(params)
      self.identity = params[:identity]
    end

    def init_user
      if same_oauth_user&.user
        auto_link
      else
        user || build_user
      end
    end

    def auto_link
      return unless same_oauth_user
      self.identity = identity.presence || same_oauth_user.identity
      self.user_id ||= same_oauth_user.user_id
      self.name ||= same_oauth_user.name
      self.avatar_url ||= same_oauth_user.avatar_url
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
      authorized_tokens.find(&->(i){ i.effective? }) || authorized_tokens.create
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

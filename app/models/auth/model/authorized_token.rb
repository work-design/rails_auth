module Auth
  module Model::AuthorizedToken
    extend ActiveSupport::Concern

    included do
      attribute :id, :uuid
      attribute :identity, :string, index: true
      attribute :expire_at, :datetime
      attribute :access_counter, :integer, default: 0
      attribute :mock_user, :boolean, default: false
      attribute :business, :string
      attribute :uid, :string
      attribute :session_id, :string
      attribute :online, :boolean
      attribute :encrypted_token, :string

      belongs_to :user, optional: true
      belongs_to :oauth_user, foreign_key: :uid, primary_key: :uid, optional: true
      belongs_to :account, ->(o) { where(user_id: o.user_id, confirmed: true) }, foreign_key: :identity, primary_key: :identity, optional: true

      has_many :sames, ->(o) { where(o.filter_hash) }, class_name: self.name, primary_key: :identity, foreign_key: :identity

      scope :valid, -> { where('expire_at >= ?', Time.current).order(expire_at: :desc) }

      after_initialize :init_expire_at, if: :new_record?
      before_validation :sync_identity, if: -> { uid.present? && uid_changed? }
      before_create :decode_from_jwt, if: -> { identity.blank? && uid.blank? }
    end

    def filter_hash
      {
        uid: self.uid,
        session_id: self.session_id
      }
    end

    def refresh
      self.class.transaction do
        r = sames.create!
        self.destroy!
        r
      end
    end

    def init_expire_at
      self.expire_at = 1.weeks.since
    end

    def sync_identity
      self.identity ||= oauth_user.identity
    end

    def expired?(now = Time.current)
      return true if self.expire_at.blank?
      self.expire_at < now
    end

    def effective?(now = Time.current)
      expire_at.present? && expire_at > now
    end

    def verify_token?(now = Time.current)
      return false if self.expire_at.blank?
      if now > self.expire_at
        self.errors.add(:token, 'The token has expired')
        return false
      end

      true
    end

    def generate_jwt_token
      payload = {
        iss: identity,
        uid: uid,
        exp_float: expire_at.to_f,
        exp: expire_at.to_i  # should be int
      }

      crypt = ActiveSupport::MessageEncryptor.new(appid, cipher: 'aes-256-gcm', serializer: :json, urlsafe: true)
      crypt.encrypt_and_sign(payload)
    end

    # 应用在业务应用中
    def decode_from_jwt
      crypt = ActiveSupport::MessageEncryptor.new(Rails.configuration.x.appid, cipher: 'aes-256-gcm', serializer: :json)
      payload = crypt.decrypt_and_verify(token)
      self.uid = payload['uid']
      init_oauth_user
      self.user = oauth_user.user
    end

    def init_oauth_user
      oauth_user || build_oauth_user(type: 'Wechat::WechatUser')
      oauth_user.init_user
      oauth_user.save
      oauth_user
    end

  end
end

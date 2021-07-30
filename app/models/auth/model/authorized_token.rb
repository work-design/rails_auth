require 'jwt'
# Usually used for access api request
module Auth
  module Model::AuthorizedToken
    extend ActiveSupport::Concern

    included do
      attribute :token, :string, index: { unique: true }
      attribute :identity, :string, index: true
      attribute :expire_at, :datetime
      attribute :session_key, :string, comment: '目前在小程序下用到'
      attribute :access_counter, :integer, default: 0
      attribute :mock_member, :boolean, default: false
      attribute :mock_user, :boolean, default: false

      belongs_to :account, foreign_key: :identity, primary_key: :identity, optional: true
      has_one :user, through: :account
      has_one :oauth_user, through: :account, source: :oauth_users
      has_many :members, class_name: 'Org::Member', foreign_key: :identity, primary_key: :identity

      scope :valid, -> { where('expire_at >= ?', Time.current).order(expire_at: :desc) }
      validates :token, presence: true

      before_validation :update_token, if: -> { new_record? }
    end

    def verify_token?(now = Time.current)
      return false if self.expire_at.blank?
      if now > self.expire_at
        self.errors.add(:token, 'The token has expired')
        return false
      end

      true
    end

    def update_token
      self.expire_at = 1.weeks.since
      self.token = generate_token
      self
    end

    def update_token!
      update_token
      save
      self
    end

    # 采用 JWT 生成 token
    # 优点1： 通过 payload 记录部分数据，可以跟服务端数据对比，或者防止服务数据删除后验证。
    def generate_token
      key = id.to_s  # todo generate key for more
      payload = {
        iss: self.id,
        exp_float: expire_at.to_f,
        exp: expire_at.to_i  # should be int
      }

      JWT.encode(payload, key.to_s)
    end

  end
end

##
# Usually used for access api request
#--
# this not docs
#++
# test
module Auth
  module Model::AuthorizedToken
    extend ActiveSupport::Concern

    included do
      attribute :token, :string, index: { unique: true }
      attribute :expire_at, :datetime
      attribute :session_key, :string, comment: '目前在小程序下用到'
      attribute :access_counter, :integer, default: 0
      attribute :mock_member, :boolean, default: false
      attribute :mock_user, :boolean, default: false
      attribute :identity, :string, index: true

      belongs_to :user, optional: true
      belongs_to :oauth_user, optional: true
      belongs_to :account, foreign_key: :identity, primary_key: :identity, optional: true
      has_many :members, foreign_key: :identity, primary_key: :identity

      scope :valid, -> { where('expire_at >= ?', Time.current).order(expire_at: :desc) }
      validates :token, presence: true

      before_validation :sync_user, if: -> { oauth_user_id_changed? || identity_changed? }
      before_validation :update_token, if: -> { new_record? }
    end

    def sync_user
      if oauth_user
        self.identity = oauth_user.account&.identity
      end
      if account
        self.user_id = account.user_id
      else
        self.user_id = nil
      end

      #self.mock_member = true if user_id != member.user_id
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

    def generate_token
      if user
        if user.password_digest
          uids = [user_id, user.password_digest]
          options = { sub: 'Auth::User', column: 'password_digest', exp_float: expire_at.to_f }
        else
          uids = [user_id, user.id]
          options = { sub: 'Auth::User', column: 'id', exp_float: expire_at.to_f }
        end
      elsif oauth_user
        uids = [oauth_user_id, oauth_user.access_token]
        options = { sub: 'Auth::OauthUser', column: 'access_token', exp_float: expire_at.to_f }
      elsif account
        uids = [account.identity, account.identity]
        options = { sub: 'Auth::Account', column: 'identity', exp_float: expire_at.to_f }
      else
        uids = []
        options = {}
      end

      JwtHelper.generate_jwt_token(*uids, exp: expire_at.to_i, **options)
    end

  end
end

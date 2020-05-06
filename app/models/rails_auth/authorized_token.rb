##
# Usually used for access api request
#--
# this not docs
#++
# test
module RailsAuth::AuthorizedToken
  extend ActiveSupport::Concern

  included do
    attribute :token, :string, index: { unique: true }
    attribute :expire_at, :datetime
    attribute :session_key, :string, comment: '目前在小程序下用到'
    attribute :access_counter, :integer, default: 0
    attribute :mock, :boolean, default: false

    belongs_to :user, optional: true
    belongs_to :oauth_user, optional: true
    belongs_to :account, optional: true
    belongs_to :organ, optional: true
    belongs_to :member, optional: true

    scope :valid, -> { where('expire_at >= ?', Time.now).order(expire_at: :desc) }
    validates :token, presence: true

    before_validation :sync_user, if: -> { oauth_user_id_changed? || account_id_changed? || member_id_changed? }
    before_validation :update_token, if: -> { new_record? }
  end

  def sync_user
    if oauth_user
      self.account_id = oauth_user.account_id
    end
    if account
      self.user_id = account.user_id
    else
      self.user_id = nil
    end
    if member
      self.organ_id = member.organ_id
      self.user_id ||= member.user_id
      self.mock = true if user_id != member.user_id
    end
  end

  def verify_token?(now = Time.now)
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
      uids = [user_id, user.password_digest || user.id]
      options = { sub: 'User', column: 'password_digest', exp_float: expire_at.to_f }
    elsif oauth_user
      uids = [oauth_user_id, oauth_user.access_token]
      options = { sub: 'OauthUser', column: 'access_token', exp_float: expire_at.to_f }
    elsif account
      uids = [account_id, account.identity]
      options = { sub: 'Account', column: 'identity', exp_float: expire_at.to_f }
    else
      uids = []
      options = {}
    end

    JwtHelper.generate_jwt_token(*uids, exp: expire_at.to_i, **options)
  end

end

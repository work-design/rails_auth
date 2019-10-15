##
# Usually used for access api request
#--
# this not docs
#++
# test
module RailsAuth::AccessToken
  extend ActiveSupport::Concern
  included do
    belongs_to :user, optional: true
    belongs_to :oauth_user, optional: true
    belongs_to :account, optional: true

    scope :valid, -> { where('expire_at >= ?', Time.now).order(access_counter: :asc) }
    validates :token, presence: true
    after_initialize :update_token, if: -> { new_record? }
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
    if account
      self.user_id = self.account.user_id
    end
    self.expire_at = 1.weeks.since
    self.token = generate_token
    self
  end
  
  def generate_token
    if user
      xbb = [user_id, user.password_digest]
    elsif oauth_user
      xbb = [oauth_user_id, oauth_user.access_token]
    elsif account
      xbb = [account_id, account.identity]
    else
      xbb = []
    end
    
    JwtHelper.generate_jwt_token(*xbb, sub: 'auth', exp: expire_at.to_i)
  end

end

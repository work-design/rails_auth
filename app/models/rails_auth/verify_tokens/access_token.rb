##
# Usually used for access api request
#--
# this not docs
#++
# test
class AccessToken < VerifyToken
  before_create :update_token

  def update_token
    self.expired_at = 1.weeks.since
    self.token = user.generate_auth_token(sub: 'auth', exp: expired_at.to_i)
  end

end

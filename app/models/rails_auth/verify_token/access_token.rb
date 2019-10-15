##
# Usually used for access api request
#--
# this not docs
#++
# test
module RailsAuth::VerifyToken::AccessToken

  def update_token
    self.expire_at = 1.weeks.since
    self.token = user.generate_auth_token(sub: 'auth', exp: expire_at.to_i)
    super
    self
  end

end

class AccessToken < VerifyToken
  include RailsAuth::VerifyToken::AccessToken
end unless defined? AccessToken

class MobileToken < VerifyToken
  include RailsAuth::VerifyToken::MobileToken
end unless defined? MobileToken

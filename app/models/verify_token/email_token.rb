class EmailToken < VerifyToken
  include RailsAuth::VerifyToken::EmailToken
end unless defined? EmailToken

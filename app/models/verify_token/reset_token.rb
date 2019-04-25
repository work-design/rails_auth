class ResetToken < VerifyToken
  include RailsAuth::VerifyToken::ResetToken
end unless defined? ResetToken

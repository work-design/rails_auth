class UnlockToken < VerifyToken
  include RailsAuth::VerifyToken::UnlockToken
end unless defined? UnlockToken

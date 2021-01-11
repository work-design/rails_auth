class EmailToken < VerifyToken
  include Auth::Model::VerifyToken::EmailToken
end unless defined? EmailToken

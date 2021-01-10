module Auth
  class EmailToken < VerifyToken
    include Model::VerifyToken::EmailToken
  end
end unless defined? Auth::EmailToken

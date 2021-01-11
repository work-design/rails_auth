module Auth
  class EmailToken < VerifyToken
    include Model::VerifyToken::EmailToken
  end unless defined? Auth::EmailToken
end

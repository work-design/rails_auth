module Auth
  class EmailToken < VerifyToken
    include Auth::Model::VerifyToken::EmailToken
  end
end

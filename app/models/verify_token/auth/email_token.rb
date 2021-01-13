module Auth
  class EmailToken < VerifyToken
    include AuthModel::VerifyToken::EmailToken
  end
end

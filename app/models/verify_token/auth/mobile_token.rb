module Auth
  class MobileToken < VerifyToken
    include AuthModel::VerifyToken::MobileToken
  end
end

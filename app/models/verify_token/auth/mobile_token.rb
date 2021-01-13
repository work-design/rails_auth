module Auth
  class MobileToken < VerifyToken
    include Auth::Model::VerifyToken::MobileToken
  end
end

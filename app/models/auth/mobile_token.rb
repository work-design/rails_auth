module Auth
  class MobileToken < VerifyToken
    include Model::VerifyToken::MobileToken
  end unless defined? Auth::MobileToken
end

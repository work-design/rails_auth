module Auth
  class MobileToken < VerifyToken
    include Model::VerifyToken::MobileToken
  end
end unless defined? Auth::MobileToken

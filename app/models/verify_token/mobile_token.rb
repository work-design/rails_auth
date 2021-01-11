class MobileToken < VerifyToken
  include Auth::Model::VerifyToken::MobileToken
end unless defined? MobileToken

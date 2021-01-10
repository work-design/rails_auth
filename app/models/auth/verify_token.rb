module Auth
  class VerifyToken < RailsAuthRecord
    include Model::VerifyToken
  end unless defined? Auth::VerifyToken
end

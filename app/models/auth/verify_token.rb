module Auth
  class VerifyToken < RailsAuthRecord
    include Model::VerifyToken
  end
end unless defined? Auth::VerifyToken

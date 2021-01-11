class VerifyToken < RailsAuthRecord
  include Auth::Model::VerifyToken
end unless defined? VerifyToken

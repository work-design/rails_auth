class AuthorizedToken < RailsAuthRecord
  include Auth::Model::AuthorizedToken
end unless defined? AuthorizedToken

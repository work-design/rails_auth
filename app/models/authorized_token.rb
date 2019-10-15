class AuthorizedToken < RailsAuthRecord
  include RailsAuth::AuthorizedToken
end unless defined? AuthorizedToken

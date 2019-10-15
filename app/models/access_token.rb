class AccessToken < RailsAuthRecord
  include RailsAuth::AccessToken
end unless defined? AccessToken

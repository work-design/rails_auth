class OauthUser < RailsAuthRecord
  include RailsAuth::OauthUser
end unless defined? OauthUser

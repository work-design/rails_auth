class OauthUser < RailsAuthRecord
  include Auth::Model::OauthUser
end unless defined? OauthUser

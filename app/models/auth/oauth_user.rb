module Auth
  class OauthUser < RailsAuthRecord
    include Model::OauthUser
  end unless defined? Auth::OauthUser
end

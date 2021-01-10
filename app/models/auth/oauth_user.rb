module Auth
  class OauthUser < RailsAuthRecord
    include Model::OauthUser
  end
end unless defined? Auth::OauthUser

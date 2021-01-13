module Auth
  class OauthUser < RailsAuthRecord
    include Auth::Model::OauthUser
  end
end

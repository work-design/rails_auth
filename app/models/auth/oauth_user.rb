module Auth
  class OauthUser < RailsAuthRecord
    include AuthModel::OauthUser
  end
end

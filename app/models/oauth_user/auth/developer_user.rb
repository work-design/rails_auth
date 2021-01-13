module Auth
  class DeveloperUser < OauthUser
    include AuthModel::OauthUser::DeveloperUser
  end
end

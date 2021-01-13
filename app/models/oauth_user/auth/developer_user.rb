module Auth
  class DeveloperUser < OauthUser
    include Auth::Model::OauthUser::DeveloperUser
  end
end

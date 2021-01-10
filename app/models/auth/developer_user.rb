module Auth
  class DeveloperUser < OauthUser
    include RailsAuth::OauthUser::DeveloperUser
  end
end unless defined? Auth::DeveloperUser

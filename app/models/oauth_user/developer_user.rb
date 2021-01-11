module Auth
  class DeveloperUser < OauthUser
    include RailsAuth::OauthUser::DeveloperUser
  end unless defined? Auth::DeveloperUser
end

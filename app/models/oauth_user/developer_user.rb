class DeveloperUser < OauthUser
  include RailsAuth::OauthUser::DeveloperUser
end unless defined? DeveloperUser

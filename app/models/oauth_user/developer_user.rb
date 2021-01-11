class DeveloperUser < OauthUser
  include Auth::Model::OauthUser::DeveloperUser
end unless defined? DeveloperUser

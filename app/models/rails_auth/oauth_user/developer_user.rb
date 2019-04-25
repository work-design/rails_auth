module RailsAuth::OauthUser::DeveloperUser
  extend ActiveSupport::Concern

  included do
    attribute :provider, :string, default: 'developer'
  end

  def save_info(oauth_params)

  end

end

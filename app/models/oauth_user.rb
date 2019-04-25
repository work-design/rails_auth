class OauthUser < RailsAuthRecord

end unless RailsAuth.config.disabled_models.include?('OauthUser')

class VerifyToken < RailsAuthRecord
  include RailsAuth::VerifyToken

end unless RailsAuth.config.disabled_models.include?('VerifyToken')


TheAuth.configure do |config|
  config.layout = :application
  config.default_user_class = 'User'
  config.access_denied_method = :access_denied      # define it in ApplicationController
  config.login_required_method = :authenticate_user! # devise auth method
end
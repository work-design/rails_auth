require 'active_support/configurable'

module TheAuth
  include ActiveSupport::Configurable

  configure do |config|
    config.layout = 'application'
    config.access_denied_method = :access_denied
    config.destroy_strategy = :restrict_with_exception
    config.app_class = 'ApplicationController'
    config.my_class = 'My::BaseController'
  end

end



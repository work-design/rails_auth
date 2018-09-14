require 'active_support/configurable'

module TheAuth
  include ActiveSupport::Configurable

  configure do |config|
    config.app_class = 'ApplicationController'
    config.my_class = 'My::BaseController'
    config.admin_class = 'Admin::BaseController'
  end

end # :nodoc:



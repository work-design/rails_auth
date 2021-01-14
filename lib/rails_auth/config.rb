require 'active_support/configurable'

module RailsAuth #:nodoc:
  include ActiveSupport::Configurable

  configure do |config|
    config.default_return_path = '/'
    config.default_home_path = '/my'
    config.ignore_return_paths = [
      'login',
      'join'
    ]
  end

end

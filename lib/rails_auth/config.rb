require 'active_support/configurable'

module RailsAuth #:nodoc:
  include ActiveSupport::Configurable

  configure do |config|
    config.default_return_hash = {
      controller: '/home'
    }
    config.default_home_path = '/'
    config.default_return = ->(user) {
      '/'
    }
  end

end

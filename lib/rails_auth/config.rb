require 'active_support/configurable'

module RailsAuth #:nodoc:
  include ActiveSupport::Configurable

  configure do |config|
    config.app_class = 'ApplicationController'
    config.my_class = 'MyController'
    config.admin_class = 'AdminController'
    config.api_class = 'ApiController'
    config.record_class = 'ApplicationRecord'
    config.disabled_models = [
      'AlipayUser',
      'WechatUser'
    ]
    config.default_return_path = '/'
    config.ignore_return_paths = [
      'login',
      'join'
    ]
  end

end



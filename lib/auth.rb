require "auth/engine"

module Auth
  class Engine < Rails::Engine

    config.middleware.insert_after ActionDispatch::Session::CookieStore, Warden::Manager do |manager|
      manager.default_strategies  :password  # 就写最常用的鉴权方式
      manager.failure_app = UserSessionsController
      manager.scope_defaults(
        :email,
        :strategies => [:password],
        :store => false,
        :action => "new_test"
      )

    end

  end
end

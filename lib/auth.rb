require "auth/engine"

module Auth
  class Engine < Rails::Engine

    config.action_view.prefix_partial_path_with_controller_namespace = false

  end
end

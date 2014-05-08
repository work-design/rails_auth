require 'the_auth/engine'
require 'the_auth/version'
require 'the_auth/config'

module TheAuth


  class Engine < Rails::Engine
    # initializer "TheRole precompile hook", group: :all do |app|
    #   app.config.assets.precompile += %w( x.js y.css )
    # end

    # http://stackoverflow.com/questions/6279325/adding-to-rails-autoload-path-from-gem
    # config.to_prepare do; end
  end

end


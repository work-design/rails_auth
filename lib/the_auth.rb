require 'the_auth/engine'
require 'the_auth/version'
require 'the_auth/config'

module TheAuth



end

_root_ = File.expand_path('../../',  __FILE__)

# Loading of concerns
require "#{_root_}/config/routes.rb"
require "#{_root_}/app/controllers/concerns/controller.rb"
require "#{_root_}/app/models/concerns/model.rb"

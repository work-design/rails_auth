ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../test/dummy/config/environment.rb',  __FILE__)
require 'rails/test_help'
require 'minitest/mock'

ActiveRecord::Migrator.migrations_paths = [File.expand_path('../../test/dummy/db/migrate', __FILE__)]
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

if defined?(FactoryBot)
  FactoryBot.definition_file_paths << TheAuth::Engine.root.join('test', 'factories')
  FactoryBot.find_definitions
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end


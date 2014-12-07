$:.push File.expand_path("../lib", __FILE__)
require "the_auth/version"

Gem::Specification.new do |s|
  s.name        = "the_auth"
  s.version     = TheAuth::VERSION
  s.authors     = ["qinmingyuan"]
  s.email       = ["mingyuan0715@foxmail.com"]
  s.homepage    = "https://github.com/qinmingyuan/the_auth"
  s.summary     = "understandable auth"
  s.description = "更容易理解的auth"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency 'rails', '4.2.0.rc1'
end
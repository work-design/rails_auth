# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "the_auth/version"

Gem::Specification.new do |s|
  s.name        = "the_auth"
  s.version     = TheAuth::VERSION
  s.authors     = ["qinmingyuan"]
  s.email       = ["mingyuan0715@foxmail.com"]
  s.homepage    = "https://github.com/qinmingyuan/auth"
  s.summary     = "understandable auth"
  s.description = "更容易理解的auth"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ['>= 3', '< 5']
  s.add_dependency 'rails_warden'

  s.add_development_dependency "sqlite3"
end
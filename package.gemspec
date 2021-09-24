Gem::Specification.new do |s|
  s.name = 'rails_auth'
  s.version = '1.2.0'
  s.authors = ['qinmingyuan']
  s.email = ['mingyuan0715@foxmail.com']
  s.homepage = 'https://github.com/work-design/rails_auth'
  s.summary = 'understandable, simple auth logic for Rails'
  s.description = '更容易理解的auth'
  s.license = 'MIT'

  s.files = Dir[
    '{app,config,db,lib}/**/*',
    'Rakefile',
    'README.md'
  ]
  s.test_files = Dir['test/**/*']
  s.require_paths = ['lib']

  s.add_dependency 'rails_com', '~> 1.2'
  s.add_dependency 'bcrypt', '~> 3.1'
  s.add_dependency 'jwt', '>= 2.0', '<= 3.0'
end

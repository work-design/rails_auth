class TheAuth::Engine < Rails::Engine
  engine_name 'the_auth'
  
  initializer 'the_auth.generator' do |app|
    app.config.generators do |g|
      g.assets false
      g.stylesheets false
      g.helper false
      g.fixture_replacement :factory_girl
    end
  end

end

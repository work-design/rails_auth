class TheAuth::Engine < Rails::Engine
  engine_name 'the_auth'

  config.generators do |g|
    g.rails = {
      assets: false,
      stylesheets: false,
      helper: false
    }
    g.test_unit = {
      fixture: true,
      fixture_replacement: :factory_girl
    }
  end

  initializer 'the_auth.assets.precompile' do |app|
    app.config.assets.precompile += ['the_auth_manifest.js']
  end

end

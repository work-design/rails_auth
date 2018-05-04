class TheAuth::Engine < ::Rails::Engine

  config.eager_load_paths += Dir[
    "#{config.root}/app/models/the_auth",
    "#{config.root}/app/models/the_auth/concerns",
    "#{config.root}/app/models/the_auth/verify_tokens"
  ]

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

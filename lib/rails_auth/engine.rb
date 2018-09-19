class RailsAuth::Engine < ::Rails::Engine

  config.eager_load_paths += Dir[
    "#{config.root}/app/models/rails_auth",
    "#{config.root}/app/models/rails_auth/concerns",
    "#{config.root}/app/models/rails_auth/verify_tokens"
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

  initializer 'rails_auth.assets.precompile' do |app|
    app.config.assets.precompile += ['rails_auth_manifest.js']
  end

end # :nodoc:

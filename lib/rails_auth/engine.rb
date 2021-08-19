require 'rails_com'
module RailsAuth
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir[
      "#{config.root}/app/models/account",
      "#{config.root}/app/models/oauth_user",
      "#{config.root}/app/models/verify_token"
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
      g.templates.prepend File.expand_path('lib/templates', RailsCom::Engine.root)
    end

    initializer 'rails_auth.action_mailers.preview' do |app|
      app.config.action_mailer.preview_path = "{#{app.config.action_mailer.preview_path.to_s.delete_prefix('{').delete_suffix('}').split(',').push(config.root.join('test/mailers/previews')).join(',')}}"
    end

  end # :nodoc:
end

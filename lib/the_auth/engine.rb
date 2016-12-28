class TheAuth::Engine < Rails::Engine
  engine_name 'the_auth'

  config.generators do |g|
    g.test_unit = {
      fixture: true,
      fixture_replacement: :factory_girl
    }
  end

end

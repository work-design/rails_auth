Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :facebook, SETTING['facebook_key'], SETTING['facebook_secret'], redirect_uri: SETTING['facebook_redirect_uri'], scope: SETTING['facebook_scope']
end

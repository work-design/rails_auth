require 'omniauth-facebook'
SETTING ||= {}

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :facebook, SETTING['f_key'], SETTING['f_secret']
end

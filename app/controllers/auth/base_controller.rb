class Auth::BaseController < RailsAuth.config.app_class.constantize
  include RailsAuthController
  default_form_builder 'AuthFromBuilder' do

  end

end

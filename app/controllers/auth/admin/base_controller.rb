class Auth::Admin::BaseController < RailsAuth.config.admin_class.constantize
  default_form_builder 'AuthAdminFormBuilder'


end

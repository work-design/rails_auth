class RailsAuthAdmin::BaseController < RailsAuth.config.admin_class.constantize
  default_form_builder 'RailsAuthAdminFormBuilder'


end

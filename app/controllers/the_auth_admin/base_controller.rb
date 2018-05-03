class TheAuthAdmin::BaseController < TheAuth.config.admin_class.constantize
  default_form_builder 'TheRoleAdminFormBuilder'


end

class RailsAuthMy::BaseController < RailsAuth.config.my_class.constantize
  before_action :require_login_from_session

end

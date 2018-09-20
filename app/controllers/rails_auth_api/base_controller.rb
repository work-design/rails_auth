class RailsAuthApi::BaseController < RailsAuth.config.api_class.constantize
  include RailsAuthApi

  def login_as user
    user.update(last_login_at: Time.now)
    @current_user = user
  end

end
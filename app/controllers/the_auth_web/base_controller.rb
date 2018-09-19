class RailsAuthWeb::BaseController < RailsAuth.config.app_class.constantize
  include TheAuthController
  default_form_builder 'RailsAuthWebBuilder' do

  end

  def login_as(user)
    session[:user_id] = user.id
    user.update(last_login_at: Time.now)
    @current_user = user
  end

end
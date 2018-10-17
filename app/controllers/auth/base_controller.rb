class Auth::BaseController < RailsAuth.config.app_class.constantize
  include RailsAuthController
  default_form_builder 'AuthBuilder' do

  end

  private
  def login_as(user)
    session[:user_id] = user.id
    user.update(last_login_at: Time.now)
    @current_user = user
  end

end

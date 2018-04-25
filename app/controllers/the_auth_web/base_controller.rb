class TheAuthWeb::BaseController < TheAuth.config.app_class.constantize
  include TheAuthController
  default_form_builder 'TheAuthWebBuilder' do

  end

  def redirect_back_or_default(default = root_url)
    redirect_to session[:return_to] || default
    session[:return_to] = nil
  end

  def login_as(user)
    session[:user_id] = user.id
    user.update(last_login_at: Time.now)
    @current_user = user
  end

end
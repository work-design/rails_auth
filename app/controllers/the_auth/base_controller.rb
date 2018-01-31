class TheAuth::BaseController < TheAuth.config.app_class.constantize
  include TheAuthCommon

  def redirect_back_or_default(default = root_url)
    redirect_to session[:return_to] || default
    session[:return_to] = nil
  end

  def store_location(path = nil)
    if [login_url, password_forget_url].include? path
      session[:return_to] = root_url
    else
      session[:return_to] = path || request.fullpath
    end
  end

  def login_as(user)
    session[:user_id] = user.id
    user.update(last_login_at: Time.now)
    @current_user = user
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
  end

end
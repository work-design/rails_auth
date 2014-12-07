module TheAuthBaseHelper

  def store_location(path = nil)
    if [login_url, user_session_url].include? path
      session[:return_to] = main_app.root_url
    else
      session[:return_to] = path || request.fullpath
    end
  end

  private

  def resource_class
    @user_class = TheAuth.default_user_class.constantize
  end


  def resource_name
    @user_name = TheAuth.default_user_class.underscore
  end


end
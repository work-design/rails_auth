module TheAuthBaseHelper

  def store_location(path = nil)
    if [login_url, user_session_url].include? path
      session[:return_to] = main_app.root_url
    else
      session[:return_to] = path || request.fullpath
    end
  end

end
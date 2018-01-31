module TheAuthCommon
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def current_user
    @current_user
  end

  def store_location(path = nil)
    if [login_url, password_forget_url].include? path
      session[:return_to] = root_url
    else
      session[:return_to] = path || request.fullpath
    end
  end

end
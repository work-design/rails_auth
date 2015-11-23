module TheAuthController
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def current_user
    @current_user ||= login_from_session
  end

  def login_from_session
    User.find_by(id: session[:user_id])
  end

  def require_login
    return if current_user
    store_location
    redirect_to login_url
  end

  def check_current_user
    unless current_user
      require_user_from_open('weixin')
    end
  end

  def require_user_from_open(provider="wechat")
    store_location
    redirect_to "/auth/#{provider}"  # 使用oauth2去拿open_id
  end

  def redirect_back_or_default(default = root_url)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def login_as(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
  end

  def store_location(path = nil)
    if [login_url, user_session_url].include? path
      session[:return_to] = root_url
    else
      session[:return_to] = path || request.fullpath
    end
  end


end
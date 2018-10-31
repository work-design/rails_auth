module RailsAuthController
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def current_user
    @current_user ||= login_from_session
  end

  def require_login_from_session
    return if login_from_session

    store_location
    if params[:form_id]
      redirect_to login_url(form_id: params[:form_id], login: params[:login])
    else
      redirect_to login_url
    end
  end

  def login_from_session
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_as(user)
    session[:user_id] = user.id
    user.update(last_login_at: Time.now)

    logger.debug "Login as User #{user.id}"

    @current_user = user
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
  end

  def store_location(path = nil)
    path = path || request.fullpath
    if ['auth/login', 'auth/join', 'auth/password'].include? request.params['controller']
      session[:return_to] = RailsAuth.config.default_return_path
    else
      session[:return_to] = path
    end
  end

  def redirect_back_or_default(default = RailsAuth.config.default_return_path, **options)
    redirect_to session[:return_to] || default, **options
    session[:return_to] = nil
  end

end

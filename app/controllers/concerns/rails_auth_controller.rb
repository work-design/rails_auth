module RailsAuthController
  extend ActiveSupport::Concern
  include RailsAuthApi

  included do
    helper_method :current_user
    after_action :set_auth_token
  end

  def api_request?
    request.headers['Auth-Token'].present? || request.format.json?
  end

  def require_login
    if api_request?
      require_login_from_token
    else
      require_login_from_session
    end
  end

  def current_user
    @current_user ||=
    if api_request?
      login_from_token
    else
      login_from_session
    end
  end

  def require_login_from_session(js_template: RailsAuth::Engine.root + 'app/views/auth/login/new.js.erb')
    return if login_from_session

    if request.xhr?
      @local = false
      render file: js_template and return
    else
      @local = true
    end

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
    if RailsAuth.config.ignore_return_paths.include? controller_path
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

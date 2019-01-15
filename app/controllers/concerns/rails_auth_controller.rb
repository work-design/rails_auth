require 'jwt'
module RailsAuthController
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    after_action :set_auth_token
  end

  def require_login(js_template: RailsAuth::Engine.root + 'app/views/auth/login/new.js.erb')
    return if login_from_token

    if api_request?
      raise ActionController::UnauthorizedError
    else
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
  end

  def current_user
    @current_user ||=
    if api_request?
      login_from_token
    else
      login_from_session
    end
  end

  def login_as(user)
    unless api_request?
      session[:auth_token] = user.auth_token
    end
    user.update(last_login_at: Time.now)

    logger.debug "Login as User #{user.id}"

    @current_user = user
  end

  def logout
    session.delete(:auth_token)
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

  def login_from_token
    auth_token = request.headers['Auth-Token'].presence || session[:auth_token]

    return unless auth_token

    if verify_auth_token
      @access_token = AccessToken.find_by token: request.headers['Auth-Token']
    end
    if @access_token
      @current_user ||= @access_token.user
    end
  end

  private
  def set_auth_token
    if api_request?
      headers['Auth-Token'] = @current_user.auth_token if @current_user
    else
      session[:auth_token] = user.auth_token
    end
  end

  def verify_auth_token
    token = request.headers['Auth-Token']
    payload = JwtHelper.decode_without_verification(token)

    return unless payload

    begin
      password_digest = User.find_by(id: payload['iss']).password_digest.to_s
      JWT.decode(token, password_digest, true, 'sub' => 'auth', verify_sub: true, verify_expiration: false)
    rescue => e
      puts nil, e.full_message(highlight: true, order: :top)
    end
  end

  def api_request?
    request.headers['Auth-Token'].present? || request.format.json?
  end

end

require 'jwt'
module RailsAuthController
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    after_action :set_auth_token
  end

  def current_user
    @current_user ||= login_from_token
  end

  def require_login(js_template: RailsAuth::Engine.root + 'app/views/auth/login/new.js.erb')
    return if current_user

    if api_request?
      raise ActionController::UnauthorizedError
    elsif request.xhr?
      @local = false
      render file: js_template and return
    else
      @local = true
      store_location
      if params[:form_id]
        redirect_to login_url(form_id: params[:form_id], login: params[:login])
      else
        redirect_to login_url
      end
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

  def login_from_token
    auth_token = request.headers['Auth-Token'].presence || session[:auth_token]
    return unless auth_token

    if verify_auth_token(auth_token)
      @current_user ||= AccessToken.find_by(token: auth_token)&.user
    end
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

  private
  def set_auth_token
    return unless @current_user
    if api_request?
      headers['Auth-Token'] = @current_user.auth_token
    else
      session[:auth_token] = @current_user.auth_token
    end
  end

  def verify_auth_token(auth_token)
    payload = JwtHelper.decode_without_verification(auth_token)
    return unless payload

    begin
      password_digest = User.find_by(id: payload['iss']).password_digest.to_s
      JWT.decode(auth_token, password_digest, true, 'sub' => 'auth', verify_sub: true, verify_expiration: false)
    rescue => e
      logger.debug e.full_message(highlight: true, order: :top)
    end
  end

  def api_request?
    request.headers['Auth-Token'].present? || request.format.json?
  end

end

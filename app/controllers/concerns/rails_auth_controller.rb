require 'jwt'
module RailsAuthController
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    after_action :set_auth_token
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user, _ = login_from_token
    @current_user
  end

  def current_account
    return @current_account if defined?(@current_account)
    _, @current_account = login_from_token
    @current_account
  end

  def require_login(js_template: RailsAuth::Engine.root + 'app/views/auth/login/new.js.erb', return_to: nil)
    return if current_user

    respond_to do |format|
      format.html {
        @local = true

        if request.get?
          return_to ||= request.fullpath
        end
        store_location(return_to)

        if params[:form_id]
          redirect_to login_url(form_id: params[:form_id], login: params[:login])
        else
          redirect_to login_url
        end
      }
      format.js {
        @local = false
        render file: js_template and return
      }
      format.json do
        render json: { message: '请登录后操作' }, status: 401
      end
    end
  end

  def login_as(account)
    unless api_request?
      session[:auth_token] = account.auth_token
    end
    account.user.update(last_login_at: Time.now)

    logger.debug "Login as User #{account.user_id}"

    @current_user = account.user
  end

  def logout
    session.delete(:auth_token)
    @current_user = nil
  end

  def login_from_token
    if request.headers['Authorization']
      auth_token = request.headers['Authorization']&.split(' ').last.presence
    else
      auth_token = request.headers['Auth-Token'].presence || session[:auth_token]
    end

    return unless auth_token

    if verify_auth_token(auth_token)
      token = AccessToken.find_by(token: auth_token)
      @current_user = token&.user
      @current_account = token&.account
      [@current_user, @current_account]
    end
  end

  def store_location(path = nil)
    return if session[:return_to]

    if path
      session[:return_to] = path
    elsif request.referer.present?
      session[:return_to] = request.referer
    end

    if session[:return_to].nil?
      return session[:return_to] = RailsAuth.config.default_return_path
    end

    path = URI(session[:return_to]).path.chomp('/')

    if RailsAuth.config.ignore_return_paths.include?(path)
      session[:return_to] = RailsAuth.config.default_return_path
    end
  end

  def redirect_back_or_default(default = RailsAuth.config.default_return_path, **options)
    redirect_to session[:return_to] || default, **options
    session[:return_to] = nil
  end

  private
  def set_auth_token
    return unless @current_account
    if api_request?
      headers['Auth-Token'] = @current_account.auth_token
    else
      session[:auth_token] = @current_account.auth_token
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

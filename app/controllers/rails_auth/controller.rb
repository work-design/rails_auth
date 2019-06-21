require 'jwt'
module RailsAuth::Controller
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
        store_location(return_to)

        if params[:form_id]
          redirect_to sign_url(form_id: params[:form_id], identity: params[:identity])
        else
          redirect_to sign_url(identity: params[:identity])
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

  def login_from_token
    if request.headers['Authorization']
      auth_token = request.headers['Authorization']&.split(' ').last.presence
    else
      auth_token = request.headers['Auth-Token'].presence || session[:auth_token]
    end

    return unless auth_token

    if verify_auth_token(auth_token)
      token = AccessToken.find_by(token: auth_token)
      if token
        token.increment! :access_counter, 1 if RailsAuth.config.enable_access_counter
        @current_user = token.user
        @current_account = token.account
        [@current_user, @current_account]
      else
        [nil, nil]
      end
    end
  end

  def sign_out
    session.delete(:auth_token)
    @current_account = nil
  end

  def store_location(path = nil)
    if path
      session[:return_to] = path
    elsif request.get?
      session[:return_to] = request.fullpath
    else
      session[:return_to] = request.referer
    end

    r_path = URI(session[:return_to]).path.delete_suffix('/')

    if RailsAuth.config.ignore_return_paths.include?(r_path)
      session[:return_to] = RailsAuth.config.default_return_path
    end
  end

  def redirect_back_or_default(default = RailsAuth.config.default_return_path, **options)
    redirect_to session[:return_to] || default, **options
    session.delete :return_to
  end

  def login_by_account(account)
    unless api_request?
      session[:auth_token] = account.auth_token
    end
  
    if params[:uid].present?
      oauth_user = OauthUser.find uid: params[:uid]
      if oauth_user
        oauth_user.account_id = account.id
        oauth_user.save
      end
    end
    account.user.update(last_login_at: Time.now)
  
    @current_account = account
    @current_user = account.user
  
    logger.debug "  ==========> Login by account as user: #{account.user_id}"
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
      password_digest = ::User.find_by(id: payload['iss']).password_digest.to_s
      JWT.decode(auth_token, password_digest, true, 'sub' => 'auth', verify_sub: true, verify_expiration: false)
    rescue => e
      session.delete :auth_token
      logger.debug e.full_message(highlight: true, order: :top)
    end
  end

  def api_request?
    request.headers['Auth-Token'].present? || request.format.json?
  end

end

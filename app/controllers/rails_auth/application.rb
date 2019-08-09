require 'jwt'
module RailsAuth::Application
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :current_account
    after_action :set_auth_token
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_access_token&.user
  end

  def current_account
    return @current_account if defined?(@current_account)
    @current_account = current_access_token&.account
  end

  def require_login(js_template: RailsAuth::Engine.root + 'app/views/auth/login/new.js.erb', return_to: nil)
    return if current_user

    respond_to do |format|
      format.html {
        store_location(return_to)

        if params[:form_id]
          redirect_to sign_url(form_id: params[:form_id], identity: params[:identity])
        else
          redirect_to sign_url(identity: params[:identity])
        end
      }
      format.js {
        render file: js_template and return
      }
      format.json do
        render json: { message: '请登录后操作' }, status: 401
      end
    end
  end

  def current_access_token
    return @current_access_token if defined?(@current_access_token)
    
    if request.headers['Authorization']
      auth_token = request.headers['Authorization']&.split(' ').last.presence
    else
      auth_token = request.headers['Auth-Token'].presence || session[:auth_token]
    end
    return unless auth_token

    if verify_auth_token(auth_token)
      @current_access_token = AccessToken.find_by(token: auth_token)
      @current_access_token.increment! :access_counter, 1 if RailsAuth.config.enable_access_counter if @current_access_token
      @current_access_token
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

  def login_by_account(account)
    if params[:uid].present?
      oauth_user = OauthUser.find_by uid: params[:uid]
    elsif params[:oauth_user_id].present?
      oauth_user = OauthUser.find_by id: params[:oauth_user_id]
    else
      oauth_user = nil
    end
    if oauth_user
      oauth_user.account_id = account.id
      oauth_user.save
    end
    
    account.user.update(last_login_at: Time.now)
  
    @current_account = account
    @current_user = account.user
  
    logger.debug "  ==========> Login by account as user: #{account.user_id}"
  end

  private
  def set_auth_token
    return unless @current_account
    
    headers['Auth-Token'] = @current_account.auth_token
    session[:auth_token] = @current_account.auth_token
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

end

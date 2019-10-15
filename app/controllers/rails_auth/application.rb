require 'jwt'
module RailsAuth::Application
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :current_account
    after_action :set_auth_token
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_authorized_token&.user
  end

  def current_account
    return @current_account if defined?(@current_account)
    @current_account = current_authorized_token&.account
  end

  def require_user(return_to: nil)
    return if current_user
    store_location(return_to)
    binding.pry
    # if params[:form_id]
    #   redirect_to sign_url(form_id: params[:form_id], identity: params[:identity])
    # else
    #   redirect_to sign_url(identity: params[:identity])
    # end
    
    render json: { message: '请登录后操作' }, status: 401
  end
  
  def require_authorized_token
    return if current_authorized_token

    render json: { message: '请登录后操作' }, status: 401
  end

  def current_authorized_token
    return @current_authorized_token if defined?(@current_authorized_token)
    
    if request.headers['Authorization']
      auth_token = request.headers['Authorization']&.split(' ').last.presence
    else
      auth_token = request.headers['Auth-Token'].presence || session[:auth_token]
    end
    return unless auth_token

    if verify_auth_token(auth_token)
      @current_authorized_token = AuthorizedToken.find_by(token: auth_token)
      @current_authorized_token.increment! :access_counter, 1 if RailsAuth.config.enable_access_counter if @current_authorized_token
      @current_authorized_token
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
      key = payload['sub'].constantize.find_by(id: payload['iss']).password_digest.to_s  # todo common password digest
      JWT.decode(auth_token, key, true, 'sub' => payload['sub'], verify_sub: true, verify_expiration: false)
    rescue => e
      session.delete :auth_token
      logger.debug e.full_message(highlight: true, order: :top)
    end
  end

end

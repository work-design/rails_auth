class Auth::OauthsController < Auth::BaseController
  skip_before_action :verify_authenticity_token

  def create
    session[:oauth_uid] = oauth_params['uid']
    type = (oauth_params[:provider].to_s + '_user').classify

    @oauth_user = OauthUser.find_or_initialize_by(type: type, uid: oauth_params[:uid])
    @oauth_user.assign_info(oauth_params)

    if @oauth_user.account.nil?
      @oauth_user.account = current_account if current_account
    end
    
    @oauth_user.save
    
    if @oauth_user.user
      login_by_oauth_user(@oauth_user)
      redirect_to session[:return_to] || RailsAuth.config.default_return_path, notice: 'Oauth Success!'
    else
      redirect_to sign_url(uid: @oauth_user.uid)
    end
    session[:return_to] = nil
  end

  def failure
    redirect_to root_url, alert: "错误: #{params[:message].humanize}"
  end

  private
  def oauth_params
    request.env['omniauth.auth']
  end

  def login_by_oauth_user(oauth_user)
    session[:auth_token] = oauth_user.account.auth_token
    oauth_user.user.update(last_login_at: Time.now)
  
    logger.debug "Login by oauth user as user: #{oauth_user.user_id}"
    @current_wechat_user = oauth_user
    @current_user = oauth_user.user
  end

end

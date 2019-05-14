class Auth::WechatController < Auth::BaseController

  def auth
    @wechat_user = WechatUser.find_or_initialize_by(uid: params[:openid])
    @wechat_user.assign_attributes params.permit(:access_token, :refresh_token, :app_id)
    @wechat_user.sync_user_info
    
    if @wechat_user.user.nil?
      @oauth_user.user = current_user if current_user
    end

    @wechat_user.save

    if @wechat_user.user
      login_by_wechat_user(@wechat_user)
      render 'auth'
    else
      render json: { oauth_user_id: @wechat_user.id }
    end
  rescue WechatApiException => e
    logger.error "微信授权失败: code: #{e.code}, message: #{e.message}"
  end

  def login_by_wechat_user(oauth_user)
    headers[:auth_token] = oauth_user.account.auth_token
    oauth_user.user.update(last_login_at: Time.now)
  
    logger.debug "Login by oauth user as user: #{oauth_user.user_id}"
    @current_wechat_user = oauth_user
    @current_user = oauth_user.user
  end
  
end

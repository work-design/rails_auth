module RailsAuthWechat
  extend ActiveSupport::Concern
  included do
    include RailsAuthController
  end

  def require_login(return_to: nil)
    return super unless request.variant.any?(:wechat)

    store_location(return_to)

    if current_wechat_user && current_wechat_user.user.nil?
      redirect_url = join_mobile_url
    else
      redirect_url = '/auth/wechat'
    end

    respond_to do |format|
      format.js { render js: "window.location.href = '#{redirect_url}'" }
      format.html { redirect_to redirect_url }
      format.json do
        render json: { status: 'error', error_message: '请登录后操作', redirect_to: redirect_url }
      end
    end
  end

  # overrided method
  def login_by_oauth(oauth_user)
    # 绑定wechat_user 和 user
    if current_wechat_user&.user_id != user.id
      current_wechat_user.update(user_id: user.id)
      user.sync_info_from_oauth_user(current_wechat_user)
    end
    super
  end

  def current_wechat_user
    return unless session[:open_id]
    @wechat_user ||= WechatUser.find_by(uid: session[:open_id])
  end

  # 需要微信授权获取openid, 但并不需要注册为用户
  def require_wechat_user(return_to: nil)
    return if current_wechat_user

    if request.get? || return_to.present?
      store_location(return_to)
    end
    redirect_url = '/auth/wechat?skip_register=true'

    respond_to do |format|
      format.js { render js: "window.location.href = '#{redirect_url}'" }
      format.html { redirect_to redirect_url }
      format.json do
        render json: { status: 'error', error_message: '请允许获取您的微信信息', redirect_to: redirect_url }
      end
    end
  end

end

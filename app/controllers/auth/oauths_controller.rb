class Auth::OauthsController < Auth::BaseController
  skip_before_action :verify_authenticity_token

  def create
    session[:open_id] = oauth_params['uid']
    type = (oauth_params[:provider].to_s + '_user').classify

    @oauth_user = OauthUser.find_or_initialize_by(type: type, uid: oauth_params[:uid])
    @oauth_user.save_info(oauth_params)

    if current_user
      @oauth_user.user = current_user
    else
      @oauth_user.save
      redirect_to join_mobile_url and return
    end

    if @oauth_user.save
      redirect_back_or_default(my_root_url, notice: 'Oauth user 创建成功')
    end
  end

  def failure
    redirect_to root_url, error: "错误: #{params[:message].humanize}"
  end

  private
  def set_oauth
    @oauth = Oauth.find(params[:id])
  end

  def oauth_params
    request.env['omniauth.auth']
  end

end

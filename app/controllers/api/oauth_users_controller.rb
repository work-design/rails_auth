class Api::OauthUsersController < Api::TheAuthController

  def create
    @oauth_user = OauthUser.find_or_initialize_by(type: oauth_user_params[:type], uid: oauth_user_params[:uid])
    @oauth_user.save_info(oauth_user_params)

    if current_user
      @oauth_user.user = current_user

      render json: {status: 200,  notice: 'Oauth user 创建成功', oauth_user: @oauth_user.as_json} if @oauth_user.save
    else
      @oauth_user.init_user
      if @oauth_user.save
        login_as @oauth_user.user
        render json: {status: 200,  notice: 'Oauth user 创建成功', oauth_user: @oauth_user.as_json}
      end
    end
  end

  private
  def oauth_user_params
    params.fetch(:oauth_user, {}).permit(:uid, :provider, :type, :name)
  end

end

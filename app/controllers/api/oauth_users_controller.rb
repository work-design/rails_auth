class Api::OauthUsersController < Api::TheAuthController
  skip_before_action :require_login

  def create
    @oauth_user = OauthUser.find_or_initialize_by(type: oauth_user_params[:type], uid: oauth_user_params[:uid])
    @oauth_user.save_info(oauth_user_params)
    @oauth_user.init_user

    if @oauth_user.save
      login_as @oauth_user.user
      render json: { oauth_user: @oauth_user.as_json, user: @oauth_user.user.as_json }
    end
  end

  private
  def oauth_user_params
    params.fetch(:oauth_user, {}).permit(:uid, :provider, :type, :name)
  end

end

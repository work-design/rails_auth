class TheAuthAdmin::OauthUsersController < TheAuthAdmin::BaseController
  before_action :set_oauth_user, only: [:show, :update, :destroy]

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @oauth_users = @user.oauth_users.page(params[:page])
    else
      @oauth_users = OauthUser.page(params[:page])
    end
  end

  def show
  end

  def update
    if @oauth_user.update(oauth_user_params)
      redirect_to @oauth_user, notice: 'Oauth user was successfully updated.'
    else
      render head: :no_content
    end
  end

  def destroy
    @oauth_user.destroy
    redirect_to oauth_users_url, notice: 'Oauth user was successfully destroyed.'
  end

  private
  def set_oauth_user
    @oauth_user = OauthUser.find(params[:id])
  end
end

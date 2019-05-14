class Auth::Admin::OauthUsersController < Auth::Admin::BaseController
  before_action :set_oauth_user, only: [:show, :update, :destroy]

  def index
    q_params = {}
    q_params.merge! params.permit(:user_id, :uid, :app_id, :name)
    @oauth_users = OauthUser.default_where(q_params).page(params[:page])
  end

  def show
  end

  def update
    if @oauth_user.update(oauth_user_params)
      redirect_to @oauth_user
    else
      render head: :no_content
    end
  end

  def destroy
    @oauth_user.destroy
    redirect_to admin_oauth_users_url(user_id: @oauth_user.user_id)
  end

  private
  def set_oauth_user
    @oauth_user = OauthUser.find(params[:id])
  end
end

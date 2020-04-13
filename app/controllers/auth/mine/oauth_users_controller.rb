class Auth::Mine::OauthUsersController < Auth::Mine::BaseController
  before_action :set_user
  before_action :set_oauth_user, only: [:show, :edit, :update, :destroy]

  def index
    @oauth_users = current_user.oauth_users
  end

  def create
    @oauth_user = OauthUser.find_or_initialize_by(type: oauth_user_params[:type], uid: oauth_user_params[:uid])
    @oauth_user.save_info(oauth_user_params)
    @oauth_user.init_user

    if @oauth_user.save
      login_by_oauth_user @oauth_user
      render json: { oauth_user: @oauth_user.as_json, user: @oauth_user.user.as_json }
    end
  end

  def bind
    @oauth_user = OauthUser.find_by(uid: params[:uid])
    @oauth_user.account = current_account

    @oauth_user.save

    redirect_to my_root_url
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @oauth_user.update(oauth_user_params)
        format.html { redirect_to @oauth_user }
        format.json { render :show, status: :ok, location: @oauth_user }
      else
        format.html { render :edit }
        format.json { render json: @oauth_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @oauth_user.destroy
  end

  private
  def set_user
    @user = current_user
  end

  def set_oauth_user
    @oauth_user = OauthUser.find(params[:id])
  end

  def oauth_user_params
    params.fetch(:oauth_user, {}).permit(
      :uid,
      :provider,
      :type,
      :name,
      :access_token
    )
  end

end

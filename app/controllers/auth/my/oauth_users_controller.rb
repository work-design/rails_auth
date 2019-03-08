class Auth::My::OauthUsersController < Auth::My::BaseController
  before_action :set_user
  before_action :set_oauth_user, only: [:show, :edit, :update, :destroy]

  def index
    @oauth_users = current_user.oauth_users
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @oauth_user.update(oauth_user_params)
        format.html { redirect_to @oauth_user, notice: 'Oauth user was successfully updated.' }
        format.json { render :show, status: :ok, location: @oauth_user }
      else
        format.html { render :edit }
        format.json { render json: @oauth_user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @oauth_user.destroy
    respond_to do |format|
      format.html { redirect_to my_oauth_users_url, notice: 'Oauth user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_user
    @user = current_user
  end

  def set_oauth_user
    @oauth_user = OauthUser.find(params[:id])
  end

end

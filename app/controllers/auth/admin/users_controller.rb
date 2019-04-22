class Auth::Admin::UsersController < Auth::Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {
      'created_at-desc': 2
    }.with_indifferent_access
    q_params.merge! params.permit(:name, :mobile, :email, 'last_login_at-desc')
    @users = User.includes(:oauth_users).default_where(q_params).page(params[:page])
  end

  def panel

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.join(params)
      redirect_to admin_users_url
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.js { redirect_to admin_users_url }
        format.html { redirect_to admin_users_url, notice: 'User was successfully updated.' }
      else
        format.js { head :no_content }
        format.html { render :edit }
      end
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url, alert: 'User was successfully destroyed.'
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params[:user].permit(
      :name,
      :avatar,
      :avatars,
      :email,
      :mobile,
      :password,
      :disabled
    )
  end

end

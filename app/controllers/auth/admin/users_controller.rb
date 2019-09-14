class Auth::Admin::UsersController < Auth::Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {
      'created_at-desc': 2
    }
    q_params.merge! params.permit(:name, 'accounts.identity', 'last_login_at-desc')
    @users = User.with_attached_avatar.includes(:oauth_users, :accounts).default_where(q_params).page(params[:page])
  end

  def panel

  end

  def new
    @user = User.new
    @user.accounts.build
  end

  def create
    @user = User.new(user_params)

    unless @user.join(params)
      render :new, locals: { model: @user }, status: :unprocessable_entity
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
        format.html { redirect_to admin_users_url }
      else
        format.js { head :no_content }
        format.html { render :edit }
      end
    end
  end

  def mock
    @user = User.find_or_initialize_by(user_uuid: params[:account])

    if @user.persisted?
      login_as @user
      render :create and return
    else
      if @user.join(user_params)
        login_as @user
        render :create and return
      end
    end

    process_errors(@user)
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params[:user].permit(
      :name,
      :avatar,
      :password,
      :disabled,
      accounts_attributes: {}
    )
  end

end

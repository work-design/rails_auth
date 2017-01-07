class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show,
                                  :edit,
                                  :update,
                                  :toggle,
                                  :destroy]

  def index
    @users = User.order(created_at: :desc).default_where(params[:q]).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_url(notice: 'User was successfully created.')
    else
      render :new
    end
  end

  def show
  end

  def edit

  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_url(notice: 'User was successfully updated.')
    else
      render :edit
    end
  end

  def toggle
    if params[:disabled] == '1'
      @user.update(disabled: true)
    else
      @user.update(disabled: false)
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url(alert: 'User was successfully destroyed.')
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params[:user].permit(:name,
                         :email,
                         :mobile,
                         :password,
                         :disabled
    )
  end

end

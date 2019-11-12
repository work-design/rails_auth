class Auth::Admin::UsersController < Auth::Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :edit_user_tags, :update_user_tags, :destroy]

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
    @user.assign_attributes user_params

    unless @user.save
      render :edit, locals: { model: @user }, status: :unprocessable_entity
    end
  end
  
  def edit_user_tags
    @user_tags = UserTag.default_where(default_params).page(params[:page])
  end
  
  def update_user_tags
    @user.assign_attributes user_params
  
    unless @user.save
      render :edit_user_tags, locals: { model: @user }, status: :unprocessable_entity
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
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.fetch(:user, {}).permit(
      :name,
      :avatar,
      :password,
      :disabled,
      user_tag_ids: [],
      accounts_attributes: {}
    )
  end

end

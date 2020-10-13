class Auth::Admin::UserTaggedsController < Auth::Admin::BaseController
  before_action :set_user_tag
  before_action :set_user_tagged, only: [:show, :edit, :update, :destroy]

  def index
    @user_taggeds = @user_tag.user_taggeds.page(params[:page])
  end

  def new
    @user_tagged = @user_tag.user_taggeds.build
  end

  def create
    @user_tagged = @user_tag.user_taggeds.build(user_tagged_params)

    unless @user_tagged.save
      render :new, locals: { model: @user_tagged }, status: :unprocessable_entity
    end
  end

  def search
    @select_ids = @user_tag.users.default_where('accounts.identity': params[:identity]).pluck(:id)
    @users = User.default_where('accounts.identity': params[:identity])
  end

  def show
  end

  def edit
  end

  def update
    @user_tagged.assign_attributes(user_tagged_params)

    unless @user_tagged.save
      render :edit, locals: { model: @user_tagged }, status: :unprocessable_entity
    end
  end

  def destroy
    @user_tagged.destroy
  end

  private
  def set_user_tag
    @user_tag = UserTag.find params[:user_tag_id]
  end

  def set_user_tagged
    @user_tagged = @user_tag.user_taggeds.find(params[:id])
  end

  def user_tagged_params
    params.fetch(:user_tagged, {}).permit(
      :tagged_type,
      :tagged_id
    )
  end

end

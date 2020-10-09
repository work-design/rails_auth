class Auth::Admin::UserTagsController < Auth::Admin::BaseController
  before_action :set_user_tag, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}
    q_params.merge! default_params

    @user_tags = UserTag.default_where(q_params).page(params[:page])
  end

  def new
    @user_tag = UserTag.new
  end

  def create
    @user_tag = UserTag.new(user_tag_params)

    unless @user_tag.save
      render :new, locals: { model: @user_tag }, status: :unprocessable_entity
    end
  end

  def show
    user_ids = @user_tag.user_taggeds.pluck(:user_id)
    @users = User.default_where(id: user_ids).order(id: :desc)
  end

  def edit
  end

  def update
    @user_tag.assign_attributes(user_tag_params)

    unless @user_tag.save
      render :edit, locals: { model: @user_tag }, status: :unprocessable_entity
    end
  end

  def destroy
    @user_tag.destroy
  end

  private
  def set_user_tag
    @user_tag = UserTag.find(params[:id])
  end

  def user_tag_params
    p = params.fetch(:user_tag, {}).permit(
      :name
    )
    p.merge! default_form_params
  end

end

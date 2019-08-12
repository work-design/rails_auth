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

    respond_to do |format|
      if @user_tag.save
        format.html.phone
        format.html { redirect_to admin_user_tags_url }
        format.js { redirect_back fallback_location: admin_user_tags_url }
        format.json { render :show }
      else
        format.html.phone { render :new }
        format.html { render :new }
        format.js { redirect_back fallback_location: admin_user_tags_url }
        format.json { render :show }
      end
    end
  end

  def show
    user_ids = @user_tag.user_taggeds.pluck(:user_id)
    @users = User.default_where(id: user_ids)
  end

  def edit
  end

  def update
    @user_tag.assign_attributes(user_tag_params)

    respond_to do |format|
      if @user_tag.save
        format.html.phone
        format.html { redirect_to admin_user_tags_url }
        format.js { redirect_back fallback_location: admin_user_tags_url }
        format.json { render :show }
      else
        format.html.phone { render :edit }
        format.html { render :edit }
        format.js { redirect_back fallback_location: admin_user_tags_url }
        format.json { render :show }
      end
    end
  end

  def destroy
    @user_tag.destroy
    redirect_to admin_user_tags_url
  end

  private
  def set_user_tag
    @user_tag = UserTag.find(params[:id])
  end

  def user_tag_params
    p = params.fetch(:user_tag, {}).permit(
      :name,
      :tagging_type
    )
    p.merge! default_form_params
  end

end

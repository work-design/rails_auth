class Auth::My::UsersController < Auth::My::BaseController
  before_action :set_user

  def show
  end

  def edit
  end

  def update
    @user.assign_attributes user_params
  
    respond_to do |format|
      if @user.save
        format.js
        format.html { redirect_to my_user_url }
        format.json {
          render json: { user: @user.as_json, filename: url_for(@user.avatar) }
        }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    redirect_to api_me_url
  end

  private
  def set_user
    @user = current_user
  end

  def user_params
    params.fetch(:user, {}).permit(
      :name,
      :avatar,
      :locale,
      :nation,
      :timezone
    )
  end

end

class Auth::My::UsersController < Auth::My::BaseController
  before_action :set_user

  def show
  end

  def update
    if @user.update(user_params)
      render :show, status: :created
    else
      process_errors(@user)
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
      :email,
      :avatar,
      :mobile,
      :locale,
      :nation,
      :timezone
    )
  end

end

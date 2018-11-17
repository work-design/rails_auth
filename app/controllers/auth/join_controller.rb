class Auth::JoinController < Auth::BaseController

  def new
    @user = User.new(password: '')
    store_location request.referer if request.referer.present?

    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @user = User.new(user_params)
    if @user.join(user_params)
      login_as @user
      respond_to do |format|
        format.html { redirect_back_or_default }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :new, error: @user.errors.full_messages }
        format.js
      end
    end
  end

  private
  def user_params
    params.fetch(:user, {}).permit(
      :name,
      :email,
      :mobile,
      :password,
      :password_confirmation
    ).merge(source: 'web')
  end

end

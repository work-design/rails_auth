class TheAuth::JoinController < TheAuth::BaseController

  def new
    @user = User.new(password: '')
    store_location request.referer if request.referer.present?
  end

  def create
    @user = User.new(user_params)
    if @user.join(params)
      login_as @user
      redirect_back_or_default
    else
      render :new, error: @user.errors.full_messages
    end
  end

  private
  def inc_ip_count
    Rails.cache.write "login/#{request.remote_ip}", ip_count + 1, expires_in: 60.seconds
  end

  def ip_count
    Rails.cache.read("login/#{request.remote_ip}").to_i
  end

  def require_recaptcha?
    ip_count >= 3
  end

  def user_params
    params.fetch(:user, {}).permit(:name, :email, :password, :password_confirmation)
  end

end

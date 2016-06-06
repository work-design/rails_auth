class TheAuth::PasswordController < TheAuth::BaseController

  def new
  end

  def create
    @user = User.find_by email: params[:login]
    if @user
      UserMailer.password_reset(@user).deliver_later
    elsif @user.blank?
      render :new, error: '用户不存在'
    else
      render :new, error: @user.errors.full_messages
    end
  end

  def edit
    @user = User.find_by(reset_token: params[:token])
    unless @user.verify_reset_token?
      render :new, error: @user.errors.full_messages
    end
  end

  def update
    @user = User.find_by(reset_token: params[:token])
    @user.clear_reset_token!
    @user.update(password: params[:password], password_confirmation: params[:password_confirmation])

    redirect_to login_url
  end

end

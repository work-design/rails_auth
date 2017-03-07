class TheAuth::PasswordController < TheAuth::BaseController

  def new
  end

  def create
    @user = User.find_by email: params[:login]
    if @user
      UserMailer.password_reset(@user.id).deliver_later
    elsif @user.blank?
      render :new, error: '用户不存在'
    else
      render :new, error: @user.errors.full_messages
    end
  end

  def edit
    reset_token = ResetToken.find_by(token: params[:token])
    @user = reset_token.user
    unless reset_token.verify_token?
      render :new, error: @user.errors.full_messages
    end
  end

  def update
    reset_token = ResetToken.find_by(token: params[:token])
    @user = reset_token.user

    User.transaction do
      reset_token.destroy!
      @user.update!(password: params[:password], password_confirmation: params[:password_confirmation])
    end

    redirect_to login_url
  end

end

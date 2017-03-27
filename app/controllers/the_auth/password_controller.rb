class TheAuth::PasswordController < TheAuth::BaseController

  def new
  end

  def create
    @user = User.find_by email: params[:login]
    @login = params[:login]
    if @user
      UserMailer.password_reset(@user.id).deliver_later
    end
  end

  def edit
    reset_token = ResetToken.find_by(token: params[:token])

    if reset_token
      @user = reset_token.user
      unless reset_token.verify_token?
        @error_message = 'Reset Token 已失效, 请重新申请'
        render :edit_error
      end
    else
      @error_message = '重置Token无效'
      render :edit_error
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

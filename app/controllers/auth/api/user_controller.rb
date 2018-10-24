class Auth::Api::UserController < Auth::Api::BaseController

  def new
    if params[:account].include?('@')
      @user = User.find_by(email: params[:account])
      if @user
        @verify_token = @user.email_token
      else
        @verify_token = EmailToken.valid.find_or_initialize_by(account: params[:account])
      end
    else
      @user = User.find_by(mobile: params[:account])
      if @user
        @verify_token = @user.mobile_token
      else
        @verify_token = MobileToken.valid.find_or_initialize_by(account: params[:account])
      end
    end

    if @verify_token.save_with_send
      render json: { code: 200, present: @user.present?, message: 'Validation code has been sent!' }
    else
      render json: { code: 401, message: 'Token is invalid' }
    end
  end

  def create
    if params[:account].include?('@')
      @user = User.find_or_initialize_by(email: params[:account])
    else
      @user = User.find_or_initialize_by(mobile: params[:account])
    end

    if @user.persisted?
      @mobile_token = @user.mobile_tokens.valid.find_by(token: params[:token]) if params[:token].present?
      @user.mobile_confirmed = true if @mobile_token
      if @user.can_login?(params)
        login_as @user
        render json: { code: 200, auth_token: @user.access_token.token, message: '登陆成功!' } and return
      end
    else
      @mobile_token = MobileToken.valid.find_by(token: params[:token], account: params[:account])

      if @mobile_token
        @user.mobile_confirmed = true
        @mobile_token.user = @user
      else
        render json: { code: 401, messages: 'Token is invalid' } and return
      end

      if @user.join(join_params)
        login_as @user
        render json: { code: 200, auth_token: @user.access_token.token, message: '注册成功!' } and return
      end
    end

    process_errors(@user)
  end

  private
  def join_params
    params.permit(
      :password,
      :password_confirmation
    )
  end

end

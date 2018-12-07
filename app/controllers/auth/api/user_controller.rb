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
      if @user.can_login?(params)
        login_as @user
        render json: { code: 200, message: '登陆成功!', user: @user.as_json(only:[:id, :name, :mobile], methods: [:auth_token, :avatar_url]) } and return
      end
    else
      @mobile_token = MobileToken.valid.find_by(token: params[:token], account: params[:account])

      if @mobile_token
        @user.mobile_confirmed = true
        @mobile_token.user = @user
      else
        render json: { code: 401, message: 'Token is invalid' } and return
      end

      if @user.join(user_params)
        login_as @user
        render json: { code: 200, message: '注册成功!', user: @user.as_json(only:[:id, :name, :mobile], methods: [:auth_token, :avatar_url]) } and return
      end
    end

    process_errors(@user)
  end

  def reset
    if params[:account].include?('@')
      @user = User.find_by(email: params[:account])
    else
      @user = User.find_by(mobile: params[:account])
    end

    unless @user
      render json: { code: 401, message: 'Please join first' } and return
    end

    @token = @user.verify_tokens.valid.find_by(token: params[:token])
    if @token
      @user.assign_attributes user_params
      if @user.save
        render json: { code: 200, message: '重置成功!', user: @user.as_json(only:[:id, :name, :mobile], methods: [:auth_token, :avatar_url]) } and return
      else
        process_errors(@user)
      end
    else
      render json: { code: 401, message: 'Token is invalid' }
    end
  end

  private
  def user_params
    params.permit(
      :password,
      :password_confirmation
    ).merge(source: 'api')
  end

end

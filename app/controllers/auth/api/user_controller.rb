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
      render json: { present: @user.present?, message: 'Validation code has been sent!' }
    else
      render json: { message: 'Token is invalid' }, status: :bad_request
    end
  end

  def create
    if params[:account].include?('@')
      @user = User.find_or_initialize_by(email: params[:account])
    else
      @user = User.find_or_initialize_by(mobile: params[:account])
    end

    if params[:token].present?
      # 注册
      if @user.persisted?
        render json: { message: '该手机号已注册' }, status: :bad_request and return
      else
        @mobile_token = MobileToken.valid.find_by(token: params[:token], account: params[:account])

        if @mobile_token
          @user.mobile_confirmed = true
          @mobile_token.user = @user
        else
          render json: { message: '验证码错误' }, status: :bad_request and return
        end

        if @user.join(user_params)
          login_as @user
          render json: { user: @user.as_json(only:[:id, :name, :mobile], methods: [:auth_token, :avatar_url]) } and return
        end
      end

    else
      # 登录
      if @user.persisted?
        if @user.can_login?(params)
          login_as @user
          render json: { user: @user.as_json(only:[:id, :name, :mobile], methods: [:auth_token, :avatar_url]) } and return
        end
      else
        render json: { message: '账号或密码错误' }, status: :bad_request and return
      end
    end

    process_errors(@user)
  end

  def mock
    @user = User.find_or_initialize_by(user_uuid: params[:account])

    if @user.persisted?
      login_as @user
      render json: { user: @user.as_json(only:[:id, :name, :mobile], methods: [:auth_token, :avatar_url]) } and return
    else
      if @user.join(user_params)
        login_as @user
        render json: { user: @user.as_json(only:[:id, :name, :mobile], methods: [:auth_token, :avatar_url]) } and return
      end
    end

    process_errors(@user)
  end

  # 40001 登陆；
  def reset
    if params[:account].include?('@')
      @user = User.find_by(email: params[:account])
    else
      @user = User.find_by(mobile: params[:account])
    end

    unless @user
      render json: { code: 40001, message: '该手机号未注册' }, status: :bad_request and return
    end

    @token = @user.verify_tokens.valid.find_by(token: params[:token])
    if @token
      @user.assign_attributes user_params
      if @user.save
        render json: { user: @user.as_json(only:[:id, :name, :mobile], methods: [:auth_token, :avatar_url]) } and return
      else
        process_errors(@user)
      end
    else
      render json: { message: '验证码错误' }, status: :bad_request
    end
  end

  private
  def user_params
    params.permit(
      :password,
      :user_uuid,
      :password_confirmation,
      :invite_token
    ).merge(source: 'api')
  end

end

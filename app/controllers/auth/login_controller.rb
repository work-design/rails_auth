class Auth::LoginController < Auth::BaseController
  if whether_filter(:require_login)
    skip_before_action :require_login
  end

  def mock
    @user = User.find_or_initialize_by(user_uuid: params[:account])

    if @user.persisted?
      login_as @user
      render :create and return
    else
      if @user.join(user_params)
        login_as @user
        render :create and return
      end
    end

    process_errors(@user)
  end

  # 40001 登陆；
  def reset
    if params[:identity].include?('@')
      @user = User.find_by(email: params[:identity])
    else
      @user = User.find_by(mobile: params[:identity])
    end

    unless @user
      render json: { code: 40001, message: '该手机号未注册' }, status: :bad_request and return
    end

    @token = @user.verify_tokens.valid.find_by(token: params[:token])
    if @token
      @user.assign_attributes user_params
      if @user.save
        render :create and return
      else
        process_errors(@user)
      end
    else
      render json: { message: '验证码错误' }, status: :bad_request
    end
  end


end



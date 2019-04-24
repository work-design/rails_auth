class Auth::LoginController < Auth::BaseController
  if whether_filter(:require_login)
    skip_before_action :require_login
  end

  def new
    @user = User.new
    store_location

    unless request.xhr? || params[:form_id]
      @local = true
    end

    respond_to do |format|
      format.html.phone
      format.html
      format.js
    end
  end

  def create
    @account = Account.find_by(identity: params[:identity])

    if @account.nil?
      msg = t('errors.messages.wrong_name_or_password')
    elsif @account.can_login?(params)
      login_as @account.user

      respond_to do |format|
        format.html { redirect_back_or_default }
        format.js
        format.json {
          render 'create_ok'
        }
      end
      return
    else
      msg = @account.user.errors.messages.values.flatten.join(' ')
    end

    flash[:error] = msg
    respond_to do |format|
      format.html { redirect_back fallback_location: login_url }
      format.js { render :new }
      format.json {
        render json: { message: msg }, status: :bad_request and return
      }
    end
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

  def destroy
    logout
    redirect_to root_url
  end

  private
  def user_params
    params.permit(
      :password,
      :user_uuid,
      :password_confirmation,
      :invite_token
    )
  end

end



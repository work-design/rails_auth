class Auth::SignController < Auth::BaseController
  before_action :set_remote, only: [:sign, :token]
  before_action :check_login, except: [:logout]

  def sign
    if params[:identity]
      @account = Account.find_by(identity: params[:identity].strip)

      if @account && @account.user
        render 'login'
      else
        render 'join'
      end
    else
      render 'sign'
    end
  end

  def token
    @account = Account.find_by(identity: params[:identity]) || Account.create_with_identity(params[:identity])
    @verify_token = @account.verify_token

    if @verify_token.send_out
      render :token, locals: { message: t('.sent') }
    else
      render :token, locals: { message: @verity_token.error_text }, status: :bad_request
    end
  end

  def mock
    @account = DeviceAccount.find_or_initialize_by(identity: params[:device_id])

    if @account.can_login?(user_params)
      login_by_account @account
      render 'login_ok'
    else
      render 'new', locals: { model: @account }, status: :unprocessable_entity
    end
  end

  def login
    @account = Account.find_by(identity: params[:identity])

    if @account
      if @account.can_login?(user_params)
        login_by_account @account
        render 'login_ok', locals: { return_to: session[:return_to] || RailsAuth.config.default_return_path, message: t('.success') }
        session.delete :return_to
      else
        render 'login', locals: { message: @account.error_text }, status: :unauthorized
      end
    else
      render 'login', locals: { message: t('errors.messages.wrong_account') }, status: :unauthorized
    end
  end

  def logout
    sign_out
  end

  private
  def user_params
    q = params.permit(
      :name,
      :identity,
      :password,
      :password_confirmation,
      :token,
      :invite_token,
      :uid,
      :device_id  # ios设备注册
    )
    if request.format.json?
      q.merge! source: 'api'
    else
      q.merge! source: 'web'
    end
    q
  end

  def check_login
    if current_user
      redirect_to RailsAuth.config.default_home_path
    end
  end

end

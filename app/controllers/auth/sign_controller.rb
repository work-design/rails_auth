class Auth::SignController < Auth::BaseController
  before_action :set_remote, only: [:sign, :token]
  before_action :check_login, except: [:logout]

  def sign
    @body = {}
    if params[:identity]
      params[:identity].strip!
      @account = Account.find_by(identity: params[:identity])
    
      if @account.present?
        if @account.user.present?
          @body.merge! present: true
        else
          @body.merge! present: false
        end
      else
        @body.merge! present: false
      end
    end
    
    if @body[:present]
      flash.now[:notice] = @body[:message] if @body[:message]
      render 'login'
    elsif @body[:present] == false
      render 'join'
    else
      render 'sign'
    end
  end

  def token
    @body = {}
    @account = Account.find_by(identity: params[:identity]) || Account.create_with_identity(params[:identity])
    @verify_token = @account.verify_token
    if @verify_token.send_out
      @body.merge! sent: true, message: t('.sent')
      @body.merge! token: @verify_token.token unless Rails.env.production?
    else
      @body.merge! message: @verity_token.errors.full_message
    end
    
    unless @body[:sent]
      render :token, status: :bad_request
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
    @body = {}
    @account = Account.find_by(identity: params[:identity])

    if @account
      if @account.can_login?(user_params)
        login_by_account @account
        @body.merge! logined: true, message: t('.success')
      else
        @body.merge! message: @account.error_text
      end
    else
      @body.merge! blank: true, message: t('errors.messages.wrong_account')
    end
    @body.merge! return_to: session[:return_to] || RailsAuth.config.default_return_path
    
    flash.now[:error] = @body[:message]
    if @body[:logined]
      render 'login_ok', locals: { return_to: session[:return_to] }
      session[:return_to] = nil
    else
      render 'login', status: :unauthorized
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

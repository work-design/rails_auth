class Auth::JoinController < Auth::BaseController
  before_action :set_user_and_token, only: [:token]
  before_action :set_user, only: [:create]

  def new
    @user = User.new
    store_location

    unless request.xhr? || params[:form_id]
      @local = true
    end

    respond_to do |format|
      format.js
      format.html
    end
  end

  def token
    if @verify_token.send_out
      respond_to do |format|
        format.html { redirect_to join_password_path(identity: user_params[:identity]) }
        format.json {
          render json: { present: @user.present?, message: 'Validation code has been sent!' }
        }
      end
    else
      respond_to do |format|
        format.html
        format.json {
          render json: { message: 'Token is invalid' }, status: :bad_request
        }
      end
    end
  end

  def join
    @user = User.new(identity: params[:identity])

    unless request.xhr? || params[:form_id]
      @local = true
    end

    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    if @user.persisted?
      @token = @user.verify_tokens.valid.find_by(token: user_params[:token])
      msg = '该手机号已注册'
      respond_to do |format|
        format.html {}
        format.json {
          render json: { message: msg }, status: :bad_request and return
        }
      end
    else
      @token = VerifyToken.valid.find_by(token: user_params[:token], account: user_params[:account])
    end

    if @token
      @account.confirmed = true
    else
      msg = t('errors.messages.wrong_token')
      flash.now[:error] = msg
      respond_to do |format|
        format.html { render :new and return }
        format.json {
          render json: { message: msg }, status: :bad_request and return
        }
      end
    end

    if @user.join(user_params)
      login_as @user
      respond_to do |format|
        format.html { redirect_back_or_default }
        format.js
        format.json {
          render json: { user: @user.as_json(only:[:id, :name, :mobile], methods: [:auth_token, :avatar_url]) } and return
        }
      end
    else
      flash.now[:error] = @user.errors.full_messages
      respond_to do |format|
        format.html { render :new, error: @user.errors.full_messages }
        format.js { render :new }
        format.json {
          process_errors(@user)
        }
      end
    end
  end

  private
  def set_user_and_token
    if user_params[:identity].include?('@')
      @user = User.find_by(email: user_params[:identity])
      if @user
        @verify_token = @user.email_token
      else
        @verify_token = EmailToken.create_with_account(user_params[:identity])
      end
    else
      @user = User.find_by(mobile: user_params[:identity])
      if @user
        @verify_token = @user.mobile_token
      else
        @verify_token = MobileToken.create_with_account(user_params[:identity])
      end
    end
  end

  def set_user
    if user_params[:identity].include?('@')
      @user = User.find_or_initialize_by(email: user_params[:identity])
    else
      @user = User.find_or_initialize_by(mobile: user_params[:identity])
    end
  end

  def user_params
    q = params.fetch(:user, {}).permit(
      :name,
      :identity,
      :password,
      :password_confirmation,
      :token
    ).merge(source: 'web')
    if q[:identity].blank?
      q.merge! params.permit(:identity)
    end
    q
  end

end

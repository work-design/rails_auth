class Auth::JoinController < Auth::BaseController
  before_action :set_user_and_token, only: [:token]
  before_action :set_user, only: [:create]

  def new
    @user = User.new(password: '')
    store_location request.referer if request.referer.present?

    unless request.xhr? || params[:form_id]
      @local = true
    end

    respond_to do |format|
      format.js
      format.html
    end
  end

  def token
    if @token.save_with_send
      render json: { code: 200, message: 'Validation code has been sent!' }
    else
      render json: { }
    end
  end

  def create
    if @user.persisted?
      @token = @user.verify_tokens.valid.find_by(token: params[:token])
    else
      @token = VerifyToken.valid.find_by(token: params[:token], account: user_params[:account])
    end

    if @token
      if @token.is_a?(MobileToken)
        @user.mobile_confirmed = true
      elsif @token.is_a?(EmailToken)
        @user.email_confirmed = true
      end
    else
      flash.now[:error] = t('errors.messages.wrong_token')
      render :new and return
    end

    if @user.join(user_params)
      login_as @user
      respond_to do |format|
        format.html { redirect_back_or_default }
        format.js
      end
    else
      flash.now[:error] = @user.errors.full_messages
      respond_to do |format|
        format.html { render :new, error: @user.errors.full_messages }
        format.js { render :new }
      end
    end
  end

  private
  def set_user_and_token
    if params[:account].include?('@')
      user = User.find_by(email: params[:account])
      if user
        @token = user.email_token
      else
        @token = EmailToken.create(account: params[:account])
      end
    else
      user = User.find_by(mobile: params[:account])
      if user
        @token = user.mobile_token
      else
        @token = MobileToken.create(account: params[:account])
      end
    end
  end

  def set_user
    if user_params[:account].include?('@')
      @user = User.find_or_initialize_by(email: user_params[:account])
    else
      @user = User.find_or_initialize_by(mobile: user_params[:account])
    end
  end

  def user_params
    params.fetch(:user, {}).permit(
      :name,
      :account,
      :password,
      :password_confirmation
    ).merge(source: 'web')
  end

end

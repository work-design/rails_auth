class Auth::JoinController < Auth::BaseController

  def new
    @user = User.new(password: '')
    store_location request.referer if request.referer.present?

    respond_to do |format|
      format.js
      format.html
    end
  end

  def confirm
    @user = User.find_by(mobile: params[:mobile])

    if @user
      @mobile_token = @user.mobile_token
    else
      @mobile_token = MobileToken.create(account: params[:mobile])
    end
    @mobile_token.send_sms

    render json: { code: 200, message: 'Validation code has been sent!' }
  end

  def create
    @user = User.find_or_initialize_by(mobile: params[:mobile])
    if @user.persisted?
      @mobile_token = @user.mobile_tokens.valid.find_by(token: params[:token])
    else
      @mobile_token = MobileToken.valid.find_by(token: params[:token], account: params[:mobile])
    end

    if @mobile_token
      @user.mobile_confirmed = true
    else
      flash.now[:error] = '验证码不正确！'
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
        format.js
      end
    end
  end

  private
  def user_params
    params.fetch(:user, {}).permit(
      :name,
      :email,
      :mobile,
      :password,
      :password_confirmation
    ).merge(source: 'web')
  end

end

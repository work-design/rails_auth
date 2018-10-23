class Auth::MobileController < Auth::BaseController

  def new
    @user = User.new(password: '')
  end

  def confirm
    @user = User.find_by(mobile: params[:mobile])

    if @user
      @mobile_token = @user.mobile_token
    else
      @mobile_token = MobileToken.create(account: params[:mobile])
    end
    @mobile_token.send_sms

    render json: { code: 200, messages: 'Validation code has been sent!' }
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

    if @user.save
      login_as @user
      redirect_back_or_default
    else
      flash.now[:error] = @user.errors.full_messages
      render :new
    end
  end

end

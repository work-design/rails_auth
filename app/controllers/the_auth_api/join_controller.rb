class TheAuthApi::JoinController < TheAuthApi::BaseController

  #**
  # @api {post} /verify Verify
  # @apiName verify
  # @apiGroup User
  #
  # @apiParam {String} mobile User mobile number
  # @apiParam {String} token Mobile verify token
  #*
  def mobile_confirm
    @user = User.find_by(mobile: params[:mobile])

    if @user
      @mobile_token = @user.create_mobile_token
    else
      @mobile_token = MobileToken.new(account: params[:mobile])
      @mobile_token.save_with_send
    end

    render json: { code: 200, messages: 'Validation code has been sent!' }
  end

  #**
  # @api {get} /verify get verify
  # @apiName get verify
  # @apiGroup User
  #
  # @apiParam {String="MobileToken","EmailToken"} type User mobile number
  # @apiParam {String} account Email or Mobile number
  #*
  def create_mobile
    @user = User.find_or_initialize_by(mobile: params[:mobile])
    if @user.persisted?
      @mobile_token = @user.mobile_tokens.valid.find_by(token: params[:token])
    else
      @mobile_token = MobileToken.valid.find_by(token: params[:token], mobile: params[:mobile])
      @user = @mobile_token.build_user if @mobile_token
    end

    if @mobile_token
      @user.mobile_confirm = true
    else
      render :new, error: 'Token is invalid' and return
    end

    if @user.save
      login_as @user
      redirect_back_or_default
    else
      render :new, error: @user.errors.full_messages
    end
  end

  #**
  # @api {post} /join Create User
  # @apiName CreateUser
  # @apiGroup User
  #
  # @apiParam {String} name User name
  # @apiParam {String} mobile User mobile number
  # @apiParam {String} token Mobile verify token
  #*
  def create
    @user = User.new(user_params)
    if @user.join(params)
      login_as @user
      redirect_back_or_default
    else
      render :new, error: @user.errors.full_messages
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
    )
  end

end

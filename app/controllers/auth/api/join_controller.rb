class Auth::Api::JoinController < Auth::Api::BaseController

  #**
  # @api {get} /verify get verify
  # @apiName get verify
  # @apiGroup User
  #
  # @apiParam {String} account Email or Mobile number
  #*
  def new_verify
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
      render json: { code: 200, messages: 'Validation code has been sent!' }
    else
      render json: { code: 401, messages: 'Token is invalid' }
    end
  end

  #**
  # @api {post} /verify_join Verify
  # @apiName verify
  # @apiGroup User
  #
  # @apiParam {String} account User mobile number
  # @apiParam {String} token Mobile verify token
  # @apiParam {String} password Password
  #*
  def create_verify
    @user = User.find_or_initialize_by(mobile: params[:account])
    if @user.persisted?
      @mobile_token = @user.mobile_tokens.valid.find_by(token: params[:token])
    else
      @mobile_token = MobileToken.valid.find_by(token: params[:token], account: params[:account])
      @user = @mobile_token.build_user(mobile: params[:account]) if @mobile_token
    end

    if @mobile_token
      @user.mobile_confirm = true
    else
      render json: { code: 401, messages: 'Token is invalid' } and return
    end

    @user.password = params[:password]
    if @user.save
      login_as @user
      render json: { auth_token: @user.access_token.token }
    else
      render json: { code: 401, messages:  @user.errors.full_messages }
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
      render json: { auth_token: @user.access_token.token }
    else
      render json: { code: 401, error: @user.errors.full_messages }
    end
  end

  private
  def set_user
    if params[:account].include?('@')
      @user = User.find_by(email: params[:account])
    else
      @user = User.find_by(mobile: params[:account])
    end
  end

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

class Auth::JoinController < Auth::BaseController
  before_action :set_account, only: [:token]
  before_action :set_remote, only: [:new, :token, :new_login]

  def new_login
    @user = User.new
    store_location

    respond_to do |format|
      format.html.phone
      format.html
      format.js
    end
  end

  def create_login
    @account = Account.find_by(identity: params[:identity])

    if @account.nil?
      msg = t('errors.messages.wrong_name_or_password')
    elsif @account.can_login?(params)
      login_as @account

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
    @verify_token = @account.verify_token
    body = {}

    if @verify_token.send_out
      body.merge! sent: true, message: 'Validation code has been sent!'
      body.merge! token: @verify_token.token unless Rails.env.production?
      body.merge! present: true, code: 1001, message: t('errors.messages.account_existed') if @account.user&.persisted?
    else
      body.merge! message: @verity_token.errors.full_message
    end

    respond_to do |format|
      format.html {
        if body[:present]
          flash.now[:error] = body[:message]
          render :new_login
        elsif body[:sent]
          render 'token'
        else
          render :new
        end
      }
      format.js
      format.json {
        if body[:sent]
          render json: body
        else
          render json: body, status: :bad_request
        end
      }
    end
  end

  def create
    @account = Account.find_by(identity: params[:identity])

    if @account
      @token = @account.check_tokens.valid.find_by(token: params[:token])
      if @token
        @account.update(confirmed: true)
        if @account.user
          @error = { code: 1001, message: t('errors.messages.account_existed') }
        elsif @account.join(user_params)
          login_as @account
          respond_to do |format|
            format.html { redirect_back_or_default notice: t('.success') }
            format.js
            format.json {
              render json: { user: @account.user.as_json(only:[:id, :name, :mobile], methods: [:auth_token, :avatar_url]) }
            }
          end
          return
        else
          @error = { code: 1004, message: @account.user.errors.full_messages }
        end
      else
        @error = { code: 1002, message: t('errors.messages.wrong_token') }
      end
    else
      @error = { code: 1002, message: t('errors.messages.wrong_account') }
    end

    flash.now[:error] = @error[:message]
    respond_to do |format|
      format.html { render :new, status: :bad_request }
      format.js { render :new }
      format.json {
        process_errors(@account.user)
      }
    end
  end

  def destroy
    logout
    redirect_to root_url
  end

  private
  def user_params
    q = params.permit(
      :name,
      :identity,
      :password,
      :password_confirmation,
      :token,
      :user_uuid,
      :invite_token
    )
    if request.format.json?
      q.merge! source: 'api'
    else
      q.merge! source: 'web'
    end
    q
  end

  def set_account
    if params[:identity].include?('@')
      @account = EmailAccount.find_or_create_by(identity: params[:identity])
    else
      @account = MobileAccount.find_or_create_by(identity: params[:identity])
    end
  end

end

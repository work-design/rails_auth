class Auth::JoinController < Auth::BaseController
  before_action :set_remote, only: [:new, :token, :new_login]
  before_action :check_login, except: [:destroy]

  def join
    store_location
    body = {}
    if params[:uid]
      @oauth_user_id = OauthUser.find_by(uid: params[:uid])&.id
    end
    if params[:identity]
      @account = Account.find_by(identity: params[:identity])
    
      if @account.present?
        if @account.user.present?
          body.merge! present: true, code: 1001, message: t('errors.messages.account_existed')
        else
          body.merge! present: false
        end
      else
        body.merge! present: false
      end
    end
  
    respond_to do |format|
      format.html do
        if body[:present]
          flash.now[:notice] = body[:message]
          render 'new_login'
        elsif body[:present] == false
          render 'new_join'
        else
          render 'join'
        end
      end
      format.js
      format.json do
        render json: body
      end
    end
  end

  def token
    body = {}
    @account = Account.find_by(identity: params[:identity]) || Account.create_with_identity(params[:identity])
    @verify_token = @account.verify_token
    if @verify_token.send_out
      body.merge! sent: true, message: t('.sent')
      body.merge! token: @verify_token.token unless Rails.env.production?
    else
      body.merge! message: @verity_token.errors.full_message
    end
    
    respond_to do |format|
      format.js
      format.json do
        if body[:sent]
          render json: body
        else
          render json: body, status: :bad_request
        end
      end
    end
  end

  def sign_in
    body = {}
    @account = Account.find_by(identity: params[:identity])

    if @account.nil?
      body.merge blank: true, message: t('errors.messages.wrong_name_or_password')
    elsif @account.can_login?(params)
      login_by_account @account
      body.merge logined: true
    else
      body.merge! message: @account.user.errors.messages.values.flatten.join(' ')
    end

    flash[:error] = body[:message]
    respond_to do |format|
      format.html do
        if body[:blank]
          redirect_to login_url(identity: params[:identity])
        else
          redirect_back_or_default
        end
      end
      format.js do
        if body[:blank]
          render :new
        else
          render 'create_login'
        end
      end
      format.json do
        if body[:blank]
          render json: { message: msg }, status: :bad_request and return
        else
          render 'create_ok'
        end
      end
    end
  end

  def sign_up
    body = {}
    @account = Account.find_by(identity: params[:identity])

    if @account
      @token = @account.check_tokens.valid.find_by(token: params[:token])
      if @token
        @account.update(confirmed: true)
        if @account.user
          body.merge! code: 1001, message: t('errors.messages.account_existed')
        elsif @account.join(user_params)
          login_by_account @account
        else
          body.merge! code: 1004, message: @account.user.errors.full_messages
        end
      else
        body.merge! code: 1002, message: t('errors.messages.wrong_token')
      end
    else
      body.merge! code: 1002, message: t('errors.messages.wrong_account')
    end

    flash.now[:error] = body[:message]
    respond_to do |format|
      format.html do
        redirect_back_or_default notice: t('.success')
      
        render :new, status: :bad_request
      end
      format.js do
        render :new
      end
      format.json do
        render json: { user: @account.user.as_json(only:[:id, :name, :mobile], methods: [:avatar_url]) }
  
        process_errors(@account.user)
      end
    end
  end

  def logout
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
  
  def check_login
    if current_user
      redirect_to my_root_url
    end
  end

end

class Auth::JoinController < Auth::BaseController
  before_action :set_remote, only: [:new, :token]
  before_action :set_account, only: [:token]

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

    if @verify_token.send_out
      respond_to do |format|
        format.html
        format.js
        format.json {
          body = { present: @user.present?, message: 'Validation code has been sent!' }
          unless Rails.env.production?
            body.merge! token: @verify_token.token
          end
          render json: body
        }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js
        format.json {
          render json: { message: @verity_token.errors.full_message }, status: :bad_request
        }
      end
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

  private
  def user_params
    q = params.permit(
      :name,
      :identity,
      :password,
      :password_confirmation,
      :token
    )
    if request.format.json?
      q.merge! source: 'api'
    else
      q.merge! source: 'web'
    end
    q
  end

end

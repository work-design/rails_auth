class Auth::Board::AccountsController < Auth::Board::BaseController
  before_action :set_account, only: [:edit, :update, :token, :confirm, :destroy]

  def index
    @accounts = current_user.accounts.order(id: :asc)
  end

  def new
    @account = Account.new
  end

  def edit
  end

  def create
    @account = current_user.accounts.build(account_params)

    if @account.save
      @account = Account.find @account.id
      @verify_token = @account.verify_token
      @verify_token.send_out
    else
      flash[:alert] = @account.error_text
      render :edit, locals: { model: @account }, status: :unprocessable_entity
    end
  end

  def update
    @account.assign_attributes(account_params)

    unless @account.save
      flash[:alert] = @account.error_text
      render :edit, locals: { model: @account }, status: :unprocessable_entity
    end
  end

  def token
    @verify_token = @account.verify_token
    @verify_token.send_out

    head :no_content
  end

  def confirm
    @token = @account.verify_tokens.valid.find_by(token: params[:token])
    if @token
      @account.confirmed = true
    else
      @account.errors.add :base, '验证码错误，请核对'
    end

    if @token && @account.save
      flash[:alert] = 'token 验证成功'
    else
      render 'error', locals: { model: @account }, status: :unprocessable_entity
    end
  end

  def destroy
    @account.destroy
  end

  private
  def set_account
    @account = current_user.accounts.find(params[:id])
  end

  def account_params
    params.require(:account).permit(
      :identity,
      :confirmed,
      :primary
    )
  end
end

class Auth::My::AccountsController < Auth::My::BaseController
  before_action :set_account, only: [:show, :edit, :update, :edit_confirm, :update_confirm, :destroy]

  def index
    @accounts = current_user.accounts
  end

  def new
    @account = Account.new
  end

  def edit
  end

  def create
    @account = current_user.accounts.build(account_params)

    if @account.save
      redirect_to my_accounts_url, notice: 'Account was successfully created.'
    end
  end

  def update
    if @account.update(account_params)
      redirect_to @account, notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  def edit_confirm
    if @account.is_a?(EmailAccount)
      @verify_token = @account.user.email_tokens.create_with_account(@account.account)
    else
      @verify_token = @account.user.mobile_tokens.create_with_account(@account.account)
    end
    @verify_token.send_out
  end

  def update_confirm
    @token = @account.user.verify_tokens.valid.find_by(token: params[:token])

    if @token
      @account.update(confirmed: true)
      redirect_to my_accounts_url, notice: 'token 验证成功'
    else
      redirect_to my_accounts_url, notice: 'token 验证失败，请重新操作'
    end
  end

  def destroy
    @account.destroy
    redirect_to my_accounts_url, notice: 'Account was successfully destroyed.'
  end

  private
  def set_account
    @account = current_user.accounts.find(params[:id])
  end

  def account_params
    params.require(:account).permit(
      :account,
      :confirmed,
      :primary
    )
  end
end

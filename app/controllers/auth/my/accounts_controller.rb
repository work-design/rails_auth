class Auth::My::AccountsController < Auth::My::BaseController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

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

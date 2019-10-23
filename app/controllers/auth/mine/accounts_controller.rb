class Auth::Mine::AccountsController < Auth::Mine::BaseController
  before_action :set_account, only: [:edit, :update, :edit_confirm, :update_confirm, :destroy]

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

    unless @account.save
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

  def edit_confirm
    @verify_token = @account.verify_token
    
    @verify_token.send_out
  end

  def update_confirm
    @token = @account.verify_tokens.valid.find_by(token: params[:token])

    if @token
      @account.update(confirmed: true)
      flash[:alert] = 'token 验证成功'
    else
      flash[:alert] = 'token 验证失败，请重新操作'
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

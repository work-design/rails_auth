module Auth
  class Board::AccountsController < Board::BaseController
    before_action :set_account, only: [:edit, :update, :token, :confirm, :select, :destroy]

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
        @account.reload
        @verify_token = @account.verify_token
        @verify_token.send_out
      else
        render :edit, locals: { model: @account }, status: :unprocessable_entity
      end
    end

    def update
      @account.assign_attributes(account_params)

      unless @account.save
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

    def select
      @current_authorized_token.update identity: @account.identity
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
end

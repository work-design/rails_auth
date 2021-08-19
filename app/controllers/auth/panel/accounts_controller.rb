module Auth
  class Panel::AccountsController < Panel::BaseController
    before_action :set_account, only: [:show, :edit, :update, :destroy]

    def index
      q_params = {}
      q_params.merge! params.permit(:user_id, :identity, :type)

      @accounts = Account.includes(:user).default_where(q_params).order(id: :desc).page(params[:page])
    end

    def new
      @account = Account.new
    end

    def create
      @account = Account.new(account_params)

      unless @account.save
        render :new, locals: { model: @account }, status: :unprocessable_entity
      end
    end

    private
    def set_account
      @account = Account.find(params[:id])
    end

    def account_params
      params.fetch(:account, {}).permit(
        :user_id,
        :identity,
        :type,
        :confirmed,
        :primary
      )
    end

  end
end

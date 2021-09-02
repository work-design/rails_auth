module Auth
  class Panel::AccountsController < Panel::BaseController

    def index
      q_params = {}
      q_params.merge! params.permit(:user_id, :identity, :type)

      @accounts = Account.includes(:user).default_where(q_params).order(id: :desc).page(params[:page])
    end

    private
    def account_permit_params
      [
        :user_id,
        :identity,
        :type,
        :confirmed,
        :primary
      ]
    end

  end
end

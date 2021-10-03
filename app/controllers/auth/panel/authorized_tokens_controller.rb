module Auth
  class Panel::AuthorizedTokensController < Panel::BaseController

    def index
      q_params = {}
      q_params.merge! params.permit(:token, :uid, :identity)
      @authorized_tokens = AuthorizedToken.default_where(q_params).order(id: :desc).page(params[:page])
    end

    private
    def authorized_token_permit_params
      [
        :token,
        :expire_at,
        :session_key
      ]
    end

  end
end

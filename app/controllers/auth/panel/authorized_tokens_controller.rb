module Auth
  class Panel::AuthorizedTokensController < Panel::BaseController

    def index
      q_params = {}
      q_params.merge! params.permit(:id, :uid, :appid, :identity)
      @authorized_tokens = AuthorizedToken.default_where(q_params)
      if params[:online]
        @authorized_tokens = @authorized_tokens.where.not(online_at: nil).where(offline_at: nil)
      end

      @authorized_tokens = @authorized_tokens.order(id: :desc).page(params[:page])
    end

    private
    def authorized_token_permit_params
      [
        :identity,
        :expire_at,
        :session_key
      ]
    end

  end
end

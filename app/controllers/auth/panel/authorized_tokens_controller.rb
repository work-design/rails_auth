class Auth::Panel::AuthorizedTokensController < Auth::Panel::BaseController
  before_action :set_authorized_token, only: [:edit, :update, :destroy]

  def index
    q_params = {}
    q_params.merge! params.permit(:token, :oauth_user_id, :user_id, :account_id)
    @authorized_tokens = AuthorizedToken.default_where(q_params).order(id: :desc).page(params[:page])
  end

  def edit
  end

  def update
    @authorized_token.assign_attributes(authorized_token_params)

    unless @authorized_token.save
      render :edit, locals: { model: @authorized_token }, status: :unprocessable_entity
    end
  end

  def destroy
    @authorized_token.destroy
  end

  private
  def set_authorized_token
    @authorized_token = AuthorizedToken.find(params[:id])
  end

  def authorized_token_params
    params.fetch(:authorized_token, {}).permit(
      :token,
      :expire_at,
      :session_key
    )
  end

end

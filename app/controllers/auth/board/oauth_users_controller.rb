module Auth
  class Board::OauthUsersController < Board::BaseController
    before_action :set_user
    before_action :set_oauth_user, only: [:show, :edit, :update, :destroy, :actions]

    def index
      @oauth_users = current_user.oauth_users.order(appid: :asc)
    end

    def create
      @oauth_user = OauthUser.find_or_initialize_by(type: oauth_user_params[:type], uid: oauth_user_params[:uid])
      @oauth_user.save_info(oauth_user_params)
      @oauth_user.init_user

      if @oauth_user.save
        login_by_account @oauth_user.account
        render json: { oauth_user: @oauth_user.as_json, user: @oauth_user.user.as_json }
      end
    end

    def bind
      @oauth_user = OauthUser.find_by(uid: params[:uid])
      @oauth_user.account = current_account
      @oauth_user.save

      redirect_to board_root_url
    end

    private
    def set_user
      @user = current_user
    end

    def set_oauth_user
      @oauth_user = OauthUser.find(params[:id])
    end

    def oauth_user_params
      params.fetch(:oauth_user, {}).permit(
        :uid,
        :provider,
        :type,
        :name,
        :access_token
      )
    end

  end
end

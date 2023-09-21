module Auth
  class Admin::OauthUsersController < Admin::BaseController
    before_action :set_oauth_user, only: [:show, :update, :destroy]

    def index
      q_params = {
        appid: current_organ.apps.pluck(:appid)
      }
      q_params.merge! params.permit(:user_id, :uid, :appid, :name)

      @oauth_users = OauthUser.default_where(q_params).order(id: :desc).page(params[:page])
    end

    private
    def set_oauth_user
      @oauth_user = OauthUser.find(params[:id])
    end

  end
end

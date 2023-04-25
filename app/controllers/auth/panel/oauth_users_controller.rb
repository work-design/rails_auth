module Auth
  class Panel::OauthUsersController < Panel::BaseController

    def index
      q_params = {}
      q_params.merge! params.permit(:identity, :uid, :unionid, :appid, :name, :user_id)

      @oauth_users = OauthUser.includes(:user).default_where(q_params).order(id: :desc).page(params[:page])
    end

    private
    def oauth_user_permit_params
      [
        :name,
        :remark
      ]
    end

  end
end

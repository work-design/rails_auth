class Auth::Api::UsersController < Auth::Api::BaseController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all

    render json: @users
  end

  def show
    render json: @user.as_json(root: true, only: [:name, :timezone, :locale, :disabled, :nation, :last_login_at, :last_login_ip, :mobile_confirmed], methods: [:avatar_url])
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

end

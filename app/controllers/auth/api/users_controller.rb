class Auth::Api::UsersController < Auth::Api::BaseController
  before_action :set_user, only: [:show]

  def index
    @users = User.page(params[:page])

    render json: @users
  end

  def show
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

end

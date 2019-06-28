class Auth::UsersController < Auth::BaseController
  before_action :set_user, only: [:show]

  def index
    @users = User.page(params[:page])

    render json: @users
  end

  def show
    respond_to do |format|
      format.js
      format.html
      format.json { render json: @user }
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end
  
end

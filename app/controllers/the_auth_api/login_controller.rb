class TheAuthApi::LoginController < TheAuthApi::BaseController
  before_action :set_user, only: [:create]

  #**
  #
  #*
  def create
    if @user && @user.can_login?(params)
      login_as @user

      render json: { status: 200, auth_token: @user.access_token.token }
    else
      render json: { error: @user.errors.messages }
    end
  end

  private
  def set_user
    if params[:account].include?('@')
      @user = User.find_by(email: params[:account])
    else
      @user = User.find_by(mobile: params[:account])
    end
  end

end



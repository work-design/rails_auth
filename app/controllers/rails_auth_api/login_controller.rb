class RailsAuthApi::LoginController < RailsAuthApi::BaseController
  before_action :set_user, only: [:create]

  #**
  #
  #*
  def create
    if @user && @user.can_login?(params)
      login_as @user

      render json: { status: 200, auth_token: @user.access_token.token }
    elsif @user.nil?
      render json: { code: 401, error: { account: '登陆失败' }, message: '请先注册账号' }, status: 401
    else
      process_errors(@user)
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



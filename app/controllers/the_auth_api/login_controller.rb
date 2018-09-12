class TheAuthApi::LoginController < TheAuthApi::BaseController
  skip_before_action :require_login_from_token, only: [:create]
  before_action :set_user, only: [:create]

  #**
  #
  #*
  def create
    if @user && @user.can_login?(params)
      login_as @user

      render json: { status: 200 }
    else
      render json: { error: @user.errors.messages }
    end
  end

  private
  def set_user
    if params[:login].include?('@')
      @user = User.find_by(email: params[:login])
    else
      @user = User.find_by(mobile: params[:login])
    end
  end

end



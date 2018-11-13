class Auth::LoginController < Auth::BaseController
  before_action :set_user, only: [:create]

  def new
    store_location request.referer if request.referer.present?
    @remote = true if params[:form_id]

    respond_to do |format|
      format.html.phone
      format.html
      format.js
    end
  end

  def create
    if @user && @user.can_login?(params)
      login_as @user

      respond_to do |format|
        format.html { redirect_back_or_default }
        format.js
      end
    else
      if @user
        flash[:error] = @user.errors.messages.values.flatten.join(' ')
      else
        flash[:error] = 'Incorrect email or password.'
      end

      respond_to do |format|
        format.html { redirect_back fallback_location: login_url }
        format.js { render :new }
      end
    end

  end

  def destroy
    logout
    redirect_to root_url
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



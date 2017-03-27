class TheAuth::LoginController < TheAuth::BaseController
  before_action :set_user, only: [:create]

  def new
    store_location request.referer if request.referer.present?
    @remote = true if params[:form_id]
  end

  def create
    if @user && @user.authenticate(params[:password])
      login_as @user

      respond_to do |format|
        format.html { redirect_back_or_default }
        format.js
      end
    else
      if @user
        flash[:error] = 'Incorrect email or password.'
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
    if params[:login].include?('@')
      @user = User.find_by(email: params[:login])
    else
      @user = User.find_by(mobile: params[:login])
    end
  end

  def inc_ip_count
    Rails.cache.write "login/#{request.remote_ip}", ip_count + 1, expires_in: 60.seconds
  end

  def ip_count
    Rails.cache.read("login/#{request.remote_ip}").to_i
  end

  def require_recaptcha?
    ip_count >= 3
  end

end



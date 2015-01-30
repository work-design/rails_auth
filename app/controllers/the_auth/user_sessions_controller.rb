class TheAuth::UserSessionsController < TheAuth::BaseController

  def new
    store_location request.referer if request.referer.present?
  end

  def create
    login = params[:login]

    if login.include?('@')
      user = User.find_by(:email => login)
    else
      user = User.find_by(:mobile => login)
    end

    if user && user.authenticate(params[:password])
      login_as user
      remember_me if params[:remember_me]

      redirect_back_or_default
    else
      flash[:error] = I18n.t('errors.messages.wrong_name_or_password')
    end
  end

  def destroy
    logout
    redirect_to root_url
  end

  private

  def inc_ip_count
    Rails.cache.write "login/#{request.remote_ip}", ip_count + 1, :expires_in => 60.seconds
  end

  def ip_count
    Rails.cache.read("login/#{request.remote_ip}").to_i
  end

  def require_recaptcha?
    ip_count >= 3
  end

end


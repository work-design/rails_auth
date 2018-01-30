module TheAuthController
  extend ActiveSupport::Concern
  include TheAuthCommon

  included do
    before_action :require_login_from_session, if: -> { request.format.html? }
  end

  def require_login_from_session
    return if current_user || login_from_session

    store_location
    if params[:form_id]
      redirect_to login_url(form_id: params[:form_id], login: params[:login])
    else
      redirect_to login_url
    end
  end

  def login_from_session
    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def store_location(path = nil)
    if [login_url, password_forget_url].include? path
      session[:return_to] = root_url
    else
      session[:return_to] = path || request.fullpath
    end
  end

end
class Auth::BaseController < RailsAuth.config.app_controller.constantize
  include RailsAuth::Controller

  def set_remote
    unless request.xhr? || params[:form_id]
      @local = true
    end
  end

  def login_by_account(account)
    unless api_request?
      session[:auth_token] = account.auth_token
    end
    account.user.update(last_login_at: Time.now)
  
    logger.debug "Login by account as user: #{account.user_id}"
    @current_account = account
    @current_user = account.user
  end

end

class Auth::BaseController < RailsAuth.config.app_controller.constantize
  include RailsAuthController


  def set_account
    if params[:identity].include?('@')
      @account = EmailAccount.find_or_create_by(identity: params[:identity])
    else
      @account = MobileAccount.find_or_create_by(identity: params[:identity])
    end
  end

  def set_remote
    unless request.xhr? || params[:form_id]
      @local = true
    end
  end

end

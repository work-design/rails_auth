class Auth::BaseController < RailsAuth.config.app_controller.constantize

  def set_remote
    unless request.xhr? || params[:form_id]
      @local = true
    end
  end

end

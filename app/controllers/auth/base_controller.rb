class Auth::BaseController < ApplicationController

  def set_remote
    unless request.xhr? || params[:form_id]
      @local = true
    end
  end

end unless defined? Auth::BaseController

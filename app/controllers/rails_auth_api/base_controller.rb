class RailsAuthApi::BaseController < ActionController::Base
  skip_before_action :verify_authenticity_token
  include RailsAuthApi
  include TheCommonApi

  def login_as user
    user.update(last_login_at: Time.now)
    @current_user = user
  end

end
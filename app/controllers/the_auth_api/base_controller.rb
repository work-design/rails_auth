class TheAuthApi::BaseController < ActionController::Base
  include TheAuthApi
  include TheCommonApi

  def login_as user
    user.update(last_login_at: Time.now)
    @current_user = user
  end

end
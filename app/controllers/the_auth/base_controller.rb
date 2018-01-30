class TheAuth::BaseController < ActionController::Base

  def login_as(user)
    session[:user_id] = user.id
    user.update(last_login_at: Time.now)
    @current_user = user
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
  end

end
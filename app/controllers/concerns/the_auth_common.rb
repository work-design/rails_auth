module TheAuthCommon
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def current_user
    @current_user
  end

  def login_as user
    user.update(last_login_at: Time.now)
    @current_user = user
  end

end
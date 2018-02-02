module TheAuthCommon
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def current_user
    @current_user
  end

end
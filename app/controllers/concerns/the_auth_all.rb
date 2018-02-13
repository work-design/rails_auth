require 'the_auth_controller'
require 'the_auth_api'

module TheAuthAll
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  def current_user
    return @current_user if @current_user
    @current_user = login_from_sesson || login_from_token
  end

end
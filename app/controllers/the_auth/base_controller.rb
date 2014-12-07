class TheAuth::BaseController < ActionController::Base
  layout  TheAuth.config.layout.to_s
  include TheAuthController

end

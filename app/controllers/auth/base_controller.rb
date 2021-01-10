class Auth::BaseController < BaseController
  include RailsAuth::Application

end unless defined? Auth::BaseController

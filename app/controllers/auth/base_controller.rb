class Auth::BaseController < BaseController
  include Auth::Controller::Application

end unless defined? Auth::BaseController

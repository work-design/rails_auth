class MineController < ApplicationController
  include RailsAuth::Wechat
  before_action :require_login
  
end unless defined? MineController

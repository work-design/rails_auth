require_dependency "the_auth/application_controller"
module TheAuth
  class UserSessionsController < ApplicationController

    after_filter :inc_ip_count, :only => :create

    def new
      store_location request.referrer if request.referrer.present?
      @session = resource.new

      message = env['warden'].message
      if message.present?
        flash[:error] = message
      end

      if request.format.to_sym == :js
        render mime_type: Mime::Type["text/html"]
      end
    end

    def create
      env['warden'].authenticate!
      user = env['warden'].user

      if user
        remember_me if params[:user][:remember_me] == '1'
        redirect_back_or_default main_app.root_path
      else
        flash[:error] = '用户名或密码不正确'
        redirect_to login_url
      end
    end

    def destroy
      env['warden'].logout
      redirect_to main_app.root_url
    end

    private

    def inc_ip_count
      Rails.cache.write "login/#{request.remote_ip}", ip_count + 1, :expires_in => 60.seconds
    end

    def ip_count
      Rails.cache.read("login/#{request.remote_ip}").to_i
    end

    def require_recaptcha?
      ip_count >= 3
    end

    def session_params
      params[:user].permit(:email, :password, :remember_me)
    end
  end
end


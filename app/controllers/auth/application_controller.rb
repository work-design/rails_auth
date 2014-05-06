module Auth
  class ApplicationController < ApplicationController
    layout 'layouts/application'


    def store_location(path = nil)
      session[:return_to] = path || request.fullpath
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def redirect_referrer_or_default(default)
      redirect_to(request.referrer || default)
    end

    def forget_me
      cookies.delete(:remember_token)
    end

    def remember_me
      cookies[:remember_token] = {
        :value   => current_user.remember_token,
        :expires => 2.weeks.from_now,
        :httponly => true
      }
    end
  end
end

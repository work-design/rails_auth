module TheAuth
  class ApplicationController < ::ApplicationController
    layout  TheAuth.config.layout.to_s


    def store_location(path = nil)
      session[:return_to] = path || request.fullpath
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
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

    private
    def resource
      @user_class = TheAuth.config.default_user_class.constantize
    end

    def resource_name
      @user_name = TheAuth.config.default_user_class.underscore
    end

  end
end

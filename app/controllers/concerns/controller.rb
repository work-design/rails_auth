require_relative 'helper'
module TheAuth
  module Controller
    include TheAuth::Helper

    def require_logined
      unless current_user
        store_location
        redirect_to login_url
      end
    end

    def require_no_logined
      if current_user
        redirect_to main_app.root_url
      end
    end

    def current_user
      request.env['warden'].authenticate
      @current_user ||= env['warden'].user
    end

    def current_user=(value)
      @current_user = value
    end

    def check_current_user
      unless current_user
        require_user_from_open('weixin')
      end
    end

    #
    #--- 获取用户 ---
    #
    def login_from_session
      logger.info "session user： #{session[:user_id]}"
      if session[:user_id].present?
        begin
          source.find session[:user_id]
        rescue
          session[:user_id] = nil
        end
      end
    end

    def require_user_from_open(provider="wechat")
      store_location
      redirect_to "/auth/#{provider}"  # 使用oauth2去拿open_id
    end

    #--- 返回 ---
    def redirect_back_or_default(default = root_path)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def login_as(user)
      session[:user_id] = user.id
      @current_user = user
    end


    def store_location(path = nil)
      session[:return_to] = path || request.fullpath
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
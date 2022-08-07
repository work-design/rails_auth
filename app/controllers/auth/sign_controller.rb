module Auth
  class SignController < BaseController
    before_action :check_login, except: [:logout]
    skip_after_action :set_auth_token, only: [:logout]
    before_action :set_oauth_user, only: [:bind, :direct, :bind_create]
    before_action :set_account, only: [:login, :token]

    def sign
      if params[:identity]
        @account = Account.find_by(identity: params[:identity].strip)

        if @account && @account.should_login_by_password?
          render 'sign_login'
        else
          render 'sign_join'
        end
      else
        render 'sign'
      end
    end

    def code
      @verify_token = VerifyToken.build_with_identity(params[:identity])

      if @verify_token.send_out!
        render 'code', locals: { message: t('.sent') }
      else
        render 'code_token', locals: { message: @verity_token.error_text }, status: :bad_request
      end
    end

    def code_login
      @verify_token = VerifyToken.build_with_identity(params[:identity])

      if @verify_token.send_out!
        render 'code_login', locals: { message: t('.sent') }
      end
    end

    def bind
    end

    def direct
      @oauth_user.generate_account
      if @oauth_user.save
        login_by_account @oauth_user.account
      end
    end

    def bind_create
      @oauth_user.can_login?(login_params)
    end

    def join
      @account = Account.build_with_identity(params[:identity])

      if @account.can_login_by_token(params)

      end
    end

    def login
      if @account.can_login_by_password?(params[:password])
        login_by_account @account

        render 'login', locals: { return_to: session[:return_to] || RailsAuth.config.default_return_path, message: t('.success') }
        session.delete :return_to
      else
        flash.now[:error] = @account.error_text.presence || @account.user.error_text
        render 'alert', locals: { message: flash.now[:error] }, status: :unauthorized
      end
    end

    def token
      if @account.can_login_by_token?(params[:token], **token_params)
        login_by_account @account

        render 'login', locals: { return_to: session[:return_to] || RailsAuth.config.default_return_path, message: t('.success') }
        session.delete :return_to
      else
        flash.now[:error] = @account.error_text.presence || @account.user.error_text
        render 'alert', locals: { message: flash.now[:error] }, status: :unauthorized
      end
    end

    def logout
      current_authorized_token&.destroy
      session.delete :auth_token
    end

    private
    def set_account
      @account = Account.find_by(identity: params[:identity].strip)
    end

    def password_params
      params.permit(:password)
    end

    def token_params
      params.permit(:token)
    end

    def login_params
      q = params.permit(
        :name,
        :identity,
        :password,
        :password_confirmation,
        :token,
        :invited_code,
        :uid,
        :device_id  # ios设备注册
      )
      q[:identity].strip!

      if session[:return_to]
        r = URI.decode_www_form(URI(session[:return_to]).query.to_s).to_h
        q.merge! invited_code: r['invited_code'] if r.key?('invited_code')
      end

      if request.format.json?
        q.merge! source: 'api'
      else
        q.merge! source: 'web'
      end
      q
    end

    def set_oauth_user
      @oauth_user = OauthUser.find_by uid: params[:uid]
    end

    def check_login
      if current_user && !request.format.json?
        redirect_to RailsAuth.config.default_home_path
      end
    end

  end
end

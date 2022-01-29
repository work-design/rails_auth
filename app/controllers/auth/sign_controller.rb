module Auth
  class SignController < BaseController
    before_action :check_login, except: [:logout]
    skip_after_action :set_auth_token, only: [:logout]

    def sign
      if params[:identity]
        @account = Account.find_by(identity: params[:identity].strip)

        if @account && @account.can_login_by_password?
          render 'login'
        else
          render 'join'
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
        render 'token', locals: { message: @verity_token.error_text }, status: :bad_request
      end
    end

    def mock
      @account = DeviceAccount.find_or_initialize_by(identity: params[:device_id])

      if @account.can_login?(user_params)
        login_by_account @account
        render 'login_ok'
      else
        render 'new', locals: { model: @account }, status: :unprocessable_entity
      end
    end

    def login
      @account = Account.build_with_identity(params[:identity])

      if @account.can_login?(user_params)
        login_by_account @account
        render 'login_ok', locals: { return_to: session[:return_to] || RailsAuth.config.default_return_path, message: t('.success') }
        session.delete :return_to
      else
        flash.now[:error] = @account.error_text.presence || @account.user.error_text
        render 'alert', locals: { message: flash.now[:error] }, status: :unauthorized
      end
    end

    def logout
      session.delete :auth_token
    end

    private
    def user_params
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

    def check_login
      if current_user && !request.format.json?
        redirect_to RailsAuth.config.default_home_path
      end
    end

  end
end

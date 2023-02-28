require 'jwt'
module Auth
  module Controller::Application
    extend ActiveSupport::Concern

    included do
      helper_method :current_user, :current_client, :current_account, :current_authorized_token
      after_action :set_auth_token
    end

    def require_user(return_to: nil)
      return if current_user
      return_hash = store_location(return_to)
      if current_authorized_token&.oauth_user
        @code = 'oauth_user'
      elsif current_authorized_token&.account
        @code = 'account'
      else
        @code = 'authorized_token'
      end

      if request.variant.include?(:mini_program)
        render 'require_program_login', locals: { url: url_for(return_hash) }
      else
        render 'require_user', locals: { url: url_for(controller: '/auth/sign', action: 'sign', identity: params[:identity]) }
      end
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_account&.user
      logger.debug "\e[35m  Current User: #{@current_user&.id}  \e[0m"
      @current_user
    end

    def client_params
      if current_client
        { member_id: current_client.id }
      elsif current_user
        { user_id: current_user.id, member_id: nil }
      else
        { user_id: nil, member_id: nil }
      end
    end

    def require_client(return_to: nil)
      return if current_client
      return_hash = store_location(return_to)

      render 'require_client', locals: { url: url_for(return_hash) }
    end

    def current_client
      return @current_client if defined?(@current_client)
      @current_client = current_authorized_token&.member
      logger.debug "\e[35m  Current Client: #{@current_client&.id}  \e[0m"
      @current_client
    end

    def current_account
      return @current_account if defined?(@current_account)

      if params[:disposable_token].present?
        begin
          dt = AuthorizedToken.find(params[:disposable_token])
          @current_account = dt.account
          @current_authorized_token = dt.refresh
        rescue ActiveRecord::RecordNotFound => e
          raise Com::DisposableTokenError
        end
      else
        @current_account = current_authorized_token&.account
      end

      logger.debug "\e[35m  Login as account: #{@current_account&.id}  \e[0m"
      @current_account
    end

    def current_authorized_token
      return @current_authorized_token if defined?(@current_authorized_token)
      token = params[:auth_token].presence || request.headers['Authorization'].to_s.split(' ').last.presence || session[:auth_token]

      return unless token
      authorized_token = AuthorizedToken.find_by(id: token)
      if authorized_token&.expired?
        @current_authorized_token = authorized_token.refresh
      elsif authorized_token.nil?
        session.delete :auth_token
      else
        @current_authorized_token = authorized_token
      end
      logger.debug "\e[35m  Current Authorized Token: #{@current_authorized_token&.id}, Destroyed: #{@current_authorized_token&.destroyed?}  \e[0m"
      @current_authorized_token
    end

    def store_location(path_hash = {})
      if path_hash.present?
        session[:request_route] = path_hash
      else
        session[:request_method] = request.method
        session[:request_body] = request.request_parameters
        session[:request_route] = request.path_parameters.merge(request.query_parameters).except(:business, :namespace, 'auth_token')
        if request.method != 'GET'
          session[:request_route].merge! return_url: Base64.urlsafe_encode64(request.referer, padding: false)
        end
      end
    end

    def login_by_account(account)
      @current_account = account
      @current_user = @current_account.user
      @current_authorized_token = @current_account.authorized_token

      logger.debug "\e[35m  Login by account #{account.id} as user: #{account.user_id}  \e[0m"
    end

    def login_by_oauth_user(oauth_user)
      @current_account = oauth_user.account
      @current_user = oauth_user.user
      @current_authorized_token = oauth_user.authorized_token

      logger.debug "\e[35m  Login by OauthUser #{oauth_user.id} as user: #{oauth_user.user&.id}  \e[0m"
    end

    def login_by_token
      token = Auth::AuthorizedToken.find_by token: params[:auth_token]
      if token
        account = token.account
        account.user || account.build_user
        account.confirmed = true
        account.save

        login_by_account(account)
      end
    end

    private
    def set_auth_token
      return unless defined?(@current_authorized_token) && @current_authorized_token

      headers['Authorization'] = @current_authorized_token.id
      session[:auth_token] = @current_authorized_token.id
      logger.debug "\e[35m  Set session Auth token: #{session[:auth_token]}  \e[0m"
    end

  end
end

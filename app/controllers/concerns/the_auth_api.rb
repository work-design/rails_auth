module TheAuthApi
  extend ActiveSupport::Concern

  included do
    before_action :login_from_token
    after_action :set_auth_token
    helper_method :current_user
  end

  def current_user
    @current_user ||= login_from_token
  end

  def set_auth_token
    headers['Auth-Token'] = current_user.get_access_token if current_user
  end

  def login_as user
    user.update(last_login_at: Time.now)
    @current_user = user
  end

  def login_from_token
    if verify_auth_token
      @access_token = AccessToken.find_by token: request.headers['HTTP_AUTH_TOKEN']
    end
    if @access_token
      @current_user ||= @access_token.user
    end
  end

  def verify_auth_token
    token = request.headers['Auth-Token']
    payload = decode_without_verification(token)

    return unless payload

    begin
      password_digest = User.find_by(id: payload['iss']).password_digest
      JWT.decode(token, password_digest, true, {'sub' => 'auth', verify_sub: true})
    rescue => e
      render(json: { error: e.message }, status: 500) and return
    end
  end

  private
  def decode_without_verification(token)
    begin
      payload, _ = JWT.decode(token, nil, false, verify_expiration: false)
    rescue => e
      render(json: { error: e.message }, status: 500) and return
    end

    payload
  end

end
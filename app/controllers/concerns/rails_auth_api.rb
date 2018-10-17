module RailsAuthApi
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    after_action :set_auth_token
  end

  def current_user
    @current_user
  end

  def require_login_from_token
    return if login_from_token

    raise ActionController::UnauthorizedError
  end

  def login_from_token
    return if request.headers['HTTP_AUTH_TOKEN'].blank?

    if verify_auth_token
      @access_token = AccessToken.find_by token: request.headers['HTTP_AUTH_TOKEN']
    end
    if @access_token
      @current_user ||= @access_token.user
    end
  end

  def login_as(user)
    user.update(last_login_at: Time.now)
    @current_user = user
  end

  private
  def set_auth_token
    headers['Auth-Token'] = @current_user.access_token.token if @current_user
  end

  def verify_auth_token
    token = request.headers['Auth-Token']
    payload = decode_without_verification(token)

    return unless payload

    begin
      password_digest = User.find_by(id: payload['iss']).password_digest.to_s
      JWT.decode(token, password_digest, true, {'sub' => 'auth', verify_sub: true})
    rescue => e
      puts nil, e.full_message(highlight: true, order: :top)
    end
  end

  def decode_without_verification(token)
    begin
      payload, _ = JWT.decode(token, nil, false, verify_expiration: false)
      payload
    rescue => e
      puts nil, e.full_message(highlight: true, order: :top)
    end
  end

end

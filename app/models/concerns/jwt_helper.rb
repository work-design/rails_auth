require 'jwt'
module JwtHelper
  extend self
  # 变量

  # algorithm

  # payload 强制 key
  # iss(issuer)放鉴权唯一标识
  # sub
  # exp

  # 模型需要定义属性
  # identifier   比如 id,  AppID
  # password_digest 比如 AppSecret
  # sub: 'auth'
  # exp: auth_token_expired_at, should be int
  def generate_jwt_token(iss, key, options = {})
    payload = {
      iss: iss,
    }

    payload.merge! options

    JWT.encode(payload, key.to_s)
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



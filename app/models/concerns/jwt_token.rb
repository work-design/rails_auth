module JwtToken
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
  def generate_auth_token(options = {})
    payload = {
      iss: identifier,
    }

    payload.merge! options

    JWT.encode(payload, password_digest.to_s)
  end
end



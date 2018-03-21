class EmailToken < VerifyToken

  def update_token
    self.token = rand(10000..999999)
    self.expired_at = 10.minutes.since
  end

  def auth_code_message
    str = "验证码：#{auth_code}，请完成验证（如非本人操作，请忽略本短信）"
    URI.encode(str)
  end

  def verify_token?
    user.update(email_confirm: true)
  end

end

# coding: utf-8
# 使用密码登陆
class PasswordStrategy < Warden::Strategies::Base

  def valid?
    params['user']
  end

  def authenticate!

    login = params['user']['email']

    if login.include?('@')
      u = resource_class.find_by(:email => login)
    else
      u = resource_class.find_by(:mobile => login)
    end

    if u.nil?
      fail! "该账号未注册"
    elsif u.password_digest.nil?
      fail! "请继续完成注册"
    else
      user = u.try(:authenticate, params['user']['password'])
      if user
        success!(user)
      else
        binding.pry
        fail! "登陆失败"
      end
    end
  end

end
